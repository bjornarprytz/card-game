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
    var block = GameSetup.new(setup_context)
    effect_block_queue.append(block)

    # Start the game loop
    advance_loop()

func _process(_delta: float) -> void:
    if pending_prompt == null:
        advance_loop()

func advance_loop() -> Array[KeywordResult]:
    # 1. If a prompt is pending, wait for player input
    if pending_prompt != null:
        push_warning("A prompt is pending, waiting for player response.")
        return []

    # 2. Resolve the next keyword in the current effect block
    resolve_next_keyword()

func validate_action(action: GameAction) -> bool:
    # Check if the action is valid in the current phase
    if current_phase and not current_phase.is_valid_action(action):
        push_warning("Action <%s> is not valid in phase <%s>" % [action.action_type, current_phase.name])
        return false
    return true

func try_take_action(action: GameAction) -> bool:
    if not validate_action(action):
        return false
    _enqueue_effect_block(action)
    return true

func resolve_next_keyword() -> KeywordResult:
    if (current_effect_block == null):
        pop_next_effect_block()
        return
    
    if not current_effect_block.has_next_keyword():
        push_error("Current effect block has no next keyword to resolve.")
        return
    
    var keyword_node = current_effect_block.next_keyword()

    if keyword_node == null:
        push_error("Keyword node is null, cannot resolve.")
        return

    return _resolve_operation_tree(keyword_node)

func pop_next_effect_block() -> void:
    if current_effect_block != null and current_effect_block.has_next_keyword():
        push_error("Cannot pop a new effect block while resolving the current one.")
        return
    
    if effect_block_queue.is_empty():
        queue_next_phase()
        return
    
    current_effect_block = effect_block_queue.pop_front()

func queue_next_phase():
    if current_phase != null and !current_phase.is_finished():
        push_error("Cannot queue next phase, current phase is not finished.")
        return
    
    if current_turn == null || current_turn.is_finished():
        start_next_turn()
        return
    
    current_phase = current_turn.get_next_phase()
    
    while (current_phase.has_next_effect_block()):
        _enqueue_effect_block(current_phase.next_effect_block())
    
    if (current_phase.allows_actions()):
        pending_prompt = GameActionPrompt.new(current_phase.allowed_actions)
        prompt_requested.emit(pending_prompt)
    else:
        push_warning("Current phase has no effect blocks and does not allow actions, waiting for next phase.")
        return

func start_next_turn():
    if !current_turn.is_finished() || !current_phase.is_finished():
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