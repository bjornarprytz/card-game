class_name GameAction
extends Resource

var action_type: String

func create_effect_block() -> EffectBlock:
	# This method should be overridden by subclasses to create the specific effect block
	push_error("create_effect_block not implemented in base GameAction class")
	return null

func _to_string() -> String:
	# Returns a string representation of the action
	return "GameAction(%s)" % action_type
