class_name Context
extends Resource

var state: GameState
var vars: Dictionary[String, VariableProto] = {}
var prompt: Dictionary[String, Variant] = {}

func _init(state_: GameState) -> void:
	state = state_
