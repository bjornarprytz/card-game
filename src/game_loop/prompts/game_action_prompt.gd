class_name GameActionPrompt
extends Prompt

var allowed_action_types: Array[String] = []

func _init(allowed_action_types_: Array[String]):
    assert(allowed_action_types_.size() > 0, "Allowed action types cannot be empty")
    
    prompt_type = "game_action"
    allowed_action_types = allowed_action_types_
    message = "Take a game action"