class_name Context
extends Resource

var state: GameState
var vars: Dictionary[String, VariableProto] = {}
var chosen_targets: Array[Variant] = []

func _init(state_: GameState) -> void:
    state = state_