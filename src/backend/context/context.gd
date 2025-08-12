class_name Context
extends Resource

var state: GameState
var vars: Dictionary[String, VariableProto] = {}
var prompt: Dictionary[String, Variant] = {}
var source: Atom

func _init(state_: GameState, source_: Atom) -> void:
	state = state_
	source = source_
