class_name GameActionPrompt
extends Prompt

var allowed_action_types: Array[String] = []

func _init(allowed_action_types_: Array[String]):
	assert(allowed_action_types_.size() > 0, "Allowed action types cannot be empty")
	
	prompt_type = "game_action"
	allowed_action_types = allowed_action_types_

func allows_action(action: GameAction) -> bool:
	if not action:
		return false
	
	# Check if the action type is in the allowed action types
	return action.action_type in allowed_action_types
