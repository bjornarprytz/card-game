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
	vars.merge(CardGameAPI.get_variables(), false) # Don't overwrite. Local variables take precedence.

func _to_string() -> String:
	return "Context: %s" % vars
