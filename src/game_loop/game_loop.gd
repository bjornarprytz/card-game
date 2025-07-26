class_name GameLoop
extends Node

signal keyword_resolved(result: KeywordResult)
signal prompt_requested(prompt: PromptNode)

@export var game_state: GameState

var current_turn: GameTurn
var current_phase: GamePhase

# Effect block queue and current effect block
var effect_block_queue: Array[EffectBlock] = []
var current_effect_block: EffectBlock = null

# Prompt state
var prompt_queue: Array[PromptNode] = []
var pending_prompt: PromptNode = null

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
		return

	# 2. Resolve the next keyword in the current effect block
	_resolve_next_keyword()

func validate_action(action: GameAction) -> bool:
	if current_phase == null:
		push_warning("No current phase to validate action against.")
		return false

	if not current_phase.allows_action(action):
		push_warning("Current phase does not allow action <%s>." % action.action_type)
		return false

	if not action.verify_costs():
		push_warning("Action <%s> costs verification failed." % action.action_type)
		return false
	
	return true

func try_take_action(action: GameAction) -> bool:
	if not validate_action(action):
		return false
	_enqueue_effect_block(action)
	return true

func validate_prompt_response(prompt_response: PromptResponse) -> bool:
	if pending_prompt == null:
		push_warning("No pending prompt to validate response against.")
		return false

	return pending_prompt.validate_response(prompt_response)

func try_prompt_response(prompt_response: PromptResponse) -> bool:
	if not validate_prompt_response(prompt_response):
		return false

	if (not pending_prompt.try_bind_response(prompt_response, current_effect_block.context)):
		push_warning("Failed to bind prompt response.")
		return false

	_resolve_operation_tree(pending_prompt)
	
	pending_prompt = null
	_pop_next_prompt()

	return true

func _resolve_next_keyword():
	if (current_effect_block == null || !current_effect_block.has_next_keyword()):
		_pop_next_effect_block()
		return
	
	if not current_effect_block.has_next_keyword():
		push_error("Current effect block has no next keyword to resolve.")
		return
	
	var keyword_node = current_effect_block.next_keyword()

	if keyword_node == null:
		push_error("Keyword node is null, cannot resolve.")
		return

	if (keyword_node is PromptNode):
		_enqueue_prompt(keyword_node)
		return

	_resolve_operation_tree(keyword_node)

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

func _queue_next_phase():
	if (pending_prompt != null):
		push_error("A prompt is pending, cannot queue another phase.")
		return
	
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
	_queue_next_phase()

func _resolve_operation_tree(operation_tree: KeywordNode) -> KeywordResult:
	var result = operation_tree.resolve()
	keyword_resolved.emit(result)
	return result

func _enqueue_prompt(prompt: PromptNode) -> void:
	if prompt == null:
		push_error("Cannot queue a null prompt.")
		return
	prompt_queue.append(prompt)

	if pending_prompt == null:
		_pop_next_prompt()

func _pop_next_prompt():
	if (pending_prompt != null):
		push_error("Cannot pop a prompt while one is pending.")
		return

	if prompt_queue.size() > 0:
		pending_prompt = prompt_queue.pop_front()
		prompt_requested.emit(pending_prompt)

func _enqueue_effect_block(effect_block: EffectBlock) -> void:
	if effect_block == null:
		push_error("Cannot enqueue a null effect block.")
		return
	effect_block_queue.append(effect_block)
	effect_block_queue.append(GameStep.new("cleanup", game_state)) ## Run this after every action to update the game state
