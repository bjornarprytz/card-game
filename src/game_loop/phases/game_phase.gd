class_name GamePhase
extends Resource

var initial_steps: Array[String] = []
var post_action_steps: Array[String] = []
var final_steps: Array[String] = []

func is_valid_action(action: GameAction) -> bool:
    return true

func is_finished(_game_state: GameState) -> bool:
    return false

func on_enter_phase(_game_state: GameState) -> void:
    pass
