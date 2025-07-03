class_name GameLoop
extends Node

signal keyword_resolved(result: KeywordResult)
signal action_taken(result: ActionResult)
signal phase_changed(new_phase: GamePhase)
signal turn_started(turn: GameTurn)
signal prompt_requested(prompt: Prompt)

@export var game_state: GameState

var current_turn: GameTurn:
    set(value):
        assert(value != null, "GameLoop requires a valid GameTurn")
        if current_turn != value:
            if current_turn:
                turn_history.append(current_turn)
            current_turn = value
            turn_started.emit(current_turn)
var current_phase: GamePhase:
    set(value):
        if current_phase != value:
            current_phase = value
            phase_changed.emit(current_phase)

var current_action: ActionResult = null
var turn_history: Array[GameTurn] = []

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

func advance_loop():
    # 1. If a prompt is pending, wait for player input
    if pending_prompt != null:
        push_warning("A prompt is pending, waiting for player response.")
        return

    # 2. If there is a current effect block, resolve its next keyword/effect
    if current_effect_block and current_effect_block.has_next_keyword():
        var keyword_node = current_effect_block.next_keyword()
        var result = _resolve_operation_tree(keyword_node)
        if result is Prompt: ## TODO: figure out how to actually start a prompt in an effect block
            if (pending_prompt != null):
                push_error("A prompt is already pending, ignoring new prompt request.")
            pending_prompt = result
            prompt_requested.emit(pending_prompt)
            return
        if result != null:
            keyword_resolved.emit(result)
            return # Wait for next _process to continue
        # If block is finished, clear it and continue
        if !current_effect_block.has_next_keyword():
            current_effect_block = null
            advance_loop()
            return

    # 3. If there are more effect blocks in the queue, start the next one
    if effect_block_queue.size() > 0:
        current_effect_block = effect_block_queue.pop_front()
        advance_loop()
        return

    # 4. If phase is finished, advance to next phase or turn
    if current_phase.is_finished():
        if current_turn.is_finished():
            var next_turn_index = turn_history.size()
            current_turn = GameTurn.new(next_turn_index)
        current_phase = current_turn.get_next_phase()
        
    if (current_phase.has_next_effect_block()):
        effect_block_queue.push_back(current_phase.next_effect_block())
    else:
        push_warning("No effect blocks available in phase <%s>, waiting for player actions." % current_phase.name)
    advance_loop()

func validate_action(action: GameAction) -> bool:
    # Check if the action is valid in the current phase
    if current_phase and not current_phase.is_valid_action(action):
        push_warning("Action <%s> is not valid in phase <%s>" % [action.action_type, current_phase.name])
        return false
    return true

func try_take_action(action: GameAction) -> bool:
    if not validate_action(action):
        return false
    effect_block_queue.append(action)
    return true

# Called by UI when the player responds to a prompt
func submit_prompt_response(prompt, response):
    if pending_prompt != prompt:
        push_warning("Received response for a prompt that is not pending!")
        return
    ## TODO: Handle the response. Probably enqueue/push an effect block
    pending_prompt = null
    advance_loop()

func _resolve_operation_tree(operation_tree: KeywordNode) -> KeywordResult:
    var result = operation_tree.resolve()
    keyword_resolved.emit(result)
    return result


