class_name StateChange
extends Mutation

var state_key: String
var value_before: Variant
var value_after: Variant

func _init(atom_: Atom, state_key_: String, value_before_: Variant, value_after_: Variant) -> void:
	atom = atom_
	state_key = state_key_
	value_before = value_before_
	value_after = value_after_

func _to_string() -> String:
	return "%s.%s:%s->%s" % [atom, state_key, value_before, value_after]
