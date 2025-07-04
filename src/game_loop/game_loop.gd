class_name GameLoop
extends Node

signal keyword_resolved(result: KeywordResult)
signal prompt_requested(prompt: Prompt)

@export var game_state: GameState

var current_turn: GameTurn
var current_phase: GamePhase

# Effect block queue and current effect block
var effect_block_queue: Array = []
var current_effect_block: EffectBlock = null

# Prompt state
var pending_prompt: Prompt = null

func _ready() -> void:
	assert(game_state != null, "The game loop needs a reference to the game state")

	var setup_context = GameSetupContext.create(game_state, CardGameAPI.get_initial_game_state())
	_enqueue_effect_block(GameSetup.new(setup_context))

	# Start the game loop
	advance_loop()

func _process(_delta: float) -> void:
	if pending_prompt == null:
		advance_loop()

func advance_loop():
	# 1. If a prompt is pending, wait for player input
	if pending_prompt != null:
		push_warning("A prompt is pending, waiting for player response.")
		return []

	# 2. Resolve the next keyword in the current effect block
	resolve_next_keyword()

func validate_action(action: GameAction) -> bool:
	# Check if the action is valid in the current phase
	if pending_prompt != null and pending_prompt is GameActionPrompt:
		var action_prompt = pending_prompt as GameActionPrompt
		return action_prompt.allows_action(action)
	return false

func try_take_action(action: GameAction) -> bool:
	if not validate_action(action):
		return false
	_enqueue_effect_block(action)
	pending_prompt = null
	return true

func resolve_next_keyword():
	if (current_effect_block == null || !current_effect_block.has_next_keyword()):
		pop_next_effect_block()
		return
	
	if not current_effect_block.has_next_keyword():
		push_error("Current effect block has no next keyword to resolve.")
		return
	
	var keyword_node = current_effect_block.next_keyword()

	if keyword_node == null:
		push_error("Keyword node is null, cannot resolve.")
		return

	_resolve_operation_tree(keyword_node)

	if (!current_effect_block.has_next_keyword()):
		print("Resolved: %s" % current_effect_block)

func pop_next_effect_block() -> void:
	if current_effect_block != null and current_effect_block.has_next_keyword():
		push_error("Cannot pop a new effect block while resolving the current one.")
		return
	
	if effect_block_queue.is_empty():
		queue_next_phase()
		return
	
	current_effect_block = effect_block_queue.pop_front()

func queue_next_phase():
	if current_phase != null and current_phase.allows_actions():
		pending_prompt = current_phase.get_action_prompt()
		prompt_requested.emit(pending_prompt)
		return
	
	if current_turn == null || current_turn.is_finished():
		start_next_turn()
		return
	
	current_phase = current_turn.get_next_phase()
	
	while (current_phase.has_next_effect_block()):
		_enqueue_effect_block(current_phase.next_effect_block())

func start_next_turn():
	if (current_turn != null && !current_turn.is_finished()) || (current_phase != null && !current_phase.is_finished()):
		push_error("Cannot start next turn, current turn or phase is not finished.")
		return
	current_turn = GameTurn.new(game_state)
	queue_next_phase()

func _resolve_operation_tree(operation_tree: KeywordNode) -> KeywordResult:
	var result = operation_tree.resolve()
	keyword_resolved.emit(result)
	return result

func _enqueue_effect_block(effect_block: EffectBlock) -> void:
	if effect_block == null:
		push_error("Cannot enqueue a null effect block.")
		return
	effect_block_queue.append(effect_block)
	effect_block_queue.append(GameStep.new("cleanup", game_state)) ## Run this after every action to update the game state
