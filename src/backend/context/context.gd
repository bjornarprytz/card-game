class_name Context
extends Resource

var state: GameState
var vars: Dictionary[String, VariableProto] = {}
var prompt: Dictionary[String, Variant] = {}

func _init(state_: GameState) -> void:
	state = state_

func answer_prompt(prompt_key: String, choices: Array) -> void:
	if prompt_key in prompt:
		push_warning("Overwriting existing prompt answer for key: %s" % prompt_key)
	prompt[prompt_key] = choices
