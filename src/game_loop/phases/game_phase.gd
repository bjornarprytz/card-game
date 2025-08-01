class_name GamePhase
extends Resource

var _remaining_steps: Array[GameStep] = []
var _allowed_actions: Array[String] = []

func _init(steps: Array[String], game_state: GameState, allowed_game_actions: Array[String] = []) -> void:
	for step_name in steps:
		var step = GameStep.new(step_name, game_state)
		_remaining_steps.append(step)
	_allowed_actions = allowed_game_actions


func has_next_effect_block() -> bool:
	return _remaining_steps.size() > 0

func next_effect_block() -> EffectBlock:
	if not has_next_effect_block():
		push_error("No more effect blocks in phase <%s>" % _remaining_steps)
		return null
	
	return _remaining_steps.pop_front()

func allows_actions() -> bool:
	return _allowed_actions.size() > 0

func allows_action(game_action: GameAction) -> bool:
	return game_action.action_type in _allowed_actions

func is_finished() -> bool:
	return !has_next_effect_block() and !allows_actions()
