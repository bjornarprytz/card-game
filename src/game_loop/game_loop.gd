class_name GameLoop
extends Node

signal keyword_resolved(event: Event, effects: Array[TriggerContext])

@export var game_state: GameState

var current_turn: GameTurn
var current_phase: GamePhase

# Effect block queue and current effect block
var effect_block_queue: Array[EffectBlock] = []
var current_effect_block: EffectBlock = null

func _ready() -> void:
	assert(game_state != null, "The game loop needs a reference to the game state")

	var setup_context = GameSetupContext.create(game_state, CardGameAPI.get_initial_game_state())
	_enqueue_effect_block(GameSetup.new(setup_context))

	# Start the game loop
	advance_loop()

func _process(_delta: float) -> void:
	advance_loop()

func advance_loop():
	_resolve_next_keyword()

func validate_action(action: GameAction) -> bool:
	if current_phase == null:
		push_warning("No current phase to validate action against.")
		return false

	if not current_phase.allows_action(action):
		return false

	if not action.try_verify_and_prepare():
		return false

	return true

func try_take_action(action: GameAction) -> bool:
	if not validate_action(action):
		return false
	_enqueue_effect_block(action)
	return true

func _resolve_next_keyword():
	if (current_effect_block == null || !current_effect_block.has_next_keyword()):
		_pop_next_effect_block()
		return
	
	if not current_effect_block.has_next_keyword():
		push_error("Current effect block has no next keyword to resolve.")
		return
	
	var event = current_effect_block.resolve_next_keyword()
	game_state.scope_provider.refresh(game_state)
	var triggered_effects = game_state.scope_provider.add_event(event)

	keyword_resolved.emit(event, triggered_effects)

	if (!current_effect_block.has_next_keyword()):
		print("Resolved: %s" % current_effect_block)

func _pop_next_effect_block() -> void:
	if current_effect_block != null and current_effect_block.has_next_keyword():
		push_error("Cannot pop a new effect block while resolving the current one.")
		return
	
	if effect_block_queue.is_empty():
		_queue_next_phase()
		return
	
	current_effect_block = effect_block_queue.pop_front()
	game_state.scope_provider.new_block()

func _queue_next_phase():
	if current_phase != null and current_phase.allows_actions():
		return
	
	if current_turn == null || current_turn.is_finished():
		_start_next_turn()
		return
	
	current_phase = current_turn.get_next_phase()
	
	while (current_phase.has_next_effect_block()):
		_enqueue_effect_block(current_phase.next_effect_block())

func _start_next_turn():
	if (current_turn != null && !current_turn.is_finished()) || (current_phase != null && !current_phase.is_finished()):
		push_error("Cannot start next turn, current turn or phase is not finished.")
		return
	current_turn = GameTurn.new(game_state)
	game_state.scope_provider.new_turn()
	_queue_next_phase()

func _enqueue_effect_block(effect_block: EffectBlock) -> void:
	if effect_block == null:
		push_error("Cannot enqueue a null effect block.")
		return
	
	effect_block_queue.append(effect_block)
	effect_block_queue.append(GameStep.new("cleanup", game_state)) ## Run this after every action to update the game state
