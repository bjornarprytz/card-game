class_name GameTurn
extends Resource

var turn_number: int = 0
var _remaining_phases: Array[GamePhase] = []

var action_history: Array[ActionResult] = []

func _init(turn_number_: int) -> void:
    turn_number = turn_number_
    _remaining_phases = [
        ## TODO: Add the actual phases of the turn here
    ]

func get_next_phase() -> GamePhase:
    if _remaining_phases.is_empty():
        return null
    return _remaining_phases.pop_front()

func add_event(event: ActionResult) -> void:
    action_history.append(event)