class_name GamePhase
extends Resource

var _steps: Array[String] = []

func _init(steps_: Array[String]) -> void:
    _steps = steps_

func get_next_step() -> GameStepProto:
    if _steps.is_empty():
        return null

    var step_name = _steps.pop_front()
    var step = CardGameAPI.get_step(step_name)
    if step == null:
        push_error("Error: Step '%s' not found in CardGameAPI" % step_name)
        return null
    
    return step

func is_valid_action(_action: GameAction, _game_state: GameState) -> bool:
    return true

func is_finished(_game_state: GameState) -> bool:
    return false

func on_enter_phase(_game_state: GameState) -> void:
    pass
