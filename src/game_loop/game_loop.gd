class_name GameLoop
extends Node

signal keyword_resolved(result: KeywordResult)
signal action_taken(result: ActionResult)
signal phase_changed(new_phase: GamePhase)
signal game_over(winner: Player)

@export var game_state: GameState

var current_turn: GameTurn = null
var current_phase: GamePhase = null
var current_step: GameStep = null
var turn_history: Array[GameTurn] = []

func _ready() -> void:
    assert(game_state != null, "The game loop needs a reference to the game state")

func setup():
    var step = CardGameAPI.get_step("setup")
    Actions.resolve_step(step, Context.new(game_state))

    ## TODO: Advance game loop

func start_turn(turn: GameTurn):
    if current_turn:
        turn_history.append(current_turn)
    current_turn = turn
    start_phase(current_turn.get_next_phase())

func start_phase(phase: GamePhase):
    current_phase = phase
    phase_changed.emit(current_phase)
    advance_step()

func advance_step():
    current_step = current_phase.get_next_step()
    if current_step == null:
        # Phase finished, advance to next phase or turn
        if not current_turn.advance_phase():
            # Turn finished, start new turn (implement turn creation logic)
            # Example: start_turn(GameTurn.new(...))
            start_turn(GameTurn.new(current_turn.turn_number + 1))
            return
        start_phase(current_turn.get_current_phase())
        return

    if current_step.requires_player_action:
        # Wait for player input (handled by try_take_action)
        return

    # Otherwise, resolve effects and advance
    current_step.resolve(game_state, Context.new(game_state))
    if not current_phase.advance_step():
        # Phase finished, handled above
        advance_step()
    else:
        advance_step()

func validate_action(action: GameAction) -> bool:
    # Check if the action is valid in the current phase
    if current_phase and not current_phase.is_valid_action(action, game_state):
        push_warning("Action <%s> is not valid in phase <%s>" % [action.name, current_phase.name])
        return false
    return true

func try_take_action(action: GameAction) -> bool:
    if not validate_action(action):
        return false
    var result = action.resolve(game_state)
    current_turn.add_event(result)
    for keyword_result in result.keyword_results:
        keyword_resolved.emit(keyword_result)
    action_taken.emit(result)

    ## TODO: Handle game over / next phase/turn logic somehow
    return true

# (Optional) If you want to keep your effect resolution helpers:
func _resolve_step(step: GameStepProto) -> void:
    _resolve_effects(step.effects, Context.new(game_state))

func _resolve_effects(effects: Array[EffectProto], context: Context) -> Array[KeywordResult]:
    var keyword_results: Array[KeywordResult] = []
    for effect in effects:
        if effect.evaluate_condition(context):
            var args = effect.resolve_args(context)
            var operation_tree = Keywords.create_operation_tree(effect.keyword, args)
            var result = operation_tree.resolve()
            keyword_results.append(result)
            keyword_resolved.emit(result)
    return keyword_results
