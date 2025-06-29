class_name GameStepProto
extends Resource

var step_name: String = ""
var effects: Array[EffectProto] = []
var actions: bool = false

func _init(step_name_: String) -> void:
	# Initialize the step with default values if needed
	step_name = step_name_
	effects = []

func add_state_effect(keyword: String) -> GameStepProto:
	var effect = EffectProto.Builder.new(keyword).add_game_state_parameter().build()
	if effect:
		effects.append(effect)
	return self

func allow_actions() -> GameStepProto:
	actions = true
	return self

static func create_steps() -> Array[GameStepProto]:
	var steps: Array[GameStepProto] = [
		GameStepProto.new("setup").add_state_effect("setup_step"),
		GameStepProto.new("upkeep").add_state_effect("upkeep_step"),
		GameStepProto.new("actions").allow_actions(),
		GameStepProto.new("end").add_state_effect("end_step"),
	]
	return steps
