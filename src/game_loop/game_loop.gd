class_name GameLoop
extends Node

signal keyword_resolved(result: KeywordResult)
signal action_taken(result: ActionResult)
signal phase_changed(new_phase: GamePhase)
signal game_over(winner: Player)

@export var game_state: GameState

var current_turn: GameTurn = null
var event_history: Array[ActionResult] = []
var turn_history: Array[GameTurn] = []

func _ready() -> void:
    assert(game_state != null, "The game loop needs a reference to the game state")

func setup():
    # Initialize the game state and set the first turn
    var first_step = CardGameAPI.get_step("setup")

    first_step.reso

    # Start the first phase
    start_phase(game_state.get_initial_phase())

func validate_action(action: GameAction) -> bool:
    # Check if the action is valid in the current phase
    if current_phase and not current_phase.is_valid_action(action):
        push_warning("Action <%s> is not valid in phase <%s>" % [action.name, current_phase.name])
        return false

    # TODO: Additional validation logic can be added here
    return true


func try_take_action(action: GameAction) -> bool:
    if not validate_action(action):
        return false
    
    var result = action.resolve(game_state)

    event_history.append(result)

    for keyword_result in result.keyword_results:
        keyword_resolved.emit(keyword_result)
    
    action_taken.emit(result)

    current_phase.is_finished(game_state)

    return true


func _resolve_step(step: GameStep) -> void:
    # TODO: Create action result for the step?
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