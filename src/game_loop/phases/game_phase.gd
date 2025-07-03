class_name GamePhase
extends Resource

var _steps: Array[GameStep] = []

var _current_step_index: int = 0

var _allowed_actions: Array[String] = []

func _init(steps: Array[String], game_state: GameState, allowed_game_actions: Array[String] = []) -> void:
    for step_name in steps:
        var step = GameStep.new(step_name, game_state)
        _steps.append(step)
    _allowed_actions = allowed_game_actions

func allows_actions() -> bool:
    return _allowed_actions.size() > 0

func is_valid_action(_action: GameAction) -> bool:
    return _allowed_actions.has(_action.action_type)

func has_next_effect_block() -> bool:
    return _current_step_index < _steps.size()

func next_effect_block() -> EffectBlock:
    if not has_next_effect_block():
        push_error("No more effect blocks in phase <%s>" % _steps)
        return null
    
    var step = _steps[_current_step_index]
    _current_step_index += 1

    return step

func is_finished() -> bool:
    return !has_next_effect_block() and !allows_actions()