class_name Context
extends Resource

var vars: Dictionary[String, VariableProto] = {}
var prompt: Dictionary[String, Variant] = {}

var state: GameState
var source: Atom
var scopes: ScopeProvider

func _init(state_: GameState, source_: Atom) -> void:
	state = state_
	source = source_
	scopes = state.scope_provider
