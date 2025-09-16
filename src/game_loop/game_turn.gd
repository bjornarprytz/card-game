class_name GameTurn
extends Resource

var _remaining_phases: Array[GamePhase] = []

func _init(game_state: GameState) -> void:
    _remaining_phases = [
        GamePhase.new([UpkeepStepDefinition.KEYWORD], game_state),
        GamePhase.new([], game_state, ["play_card", "end_turn"]),
        GamePhase.new([EndStepDefinition.KEYWORD], game_state),
    ]

func is_finished() -> bool:
    return _remaining_phases.is_empty()

func get_next_phase() -> GamePhase:
    return _remaining_phases.pop_front()
