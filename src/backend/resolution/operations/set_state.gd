class_name SetState
extends Operation

var atom: Atom
var key: String
var value: Variant
var default_zero: Variant

func _init(atom_: Atom, key_: String, value_: Variant, default_zero_: Variant) -> void:
	if (default_zero_ != null and typeof(default_zero_) != typeof(value_)):
		push_error("Type mismatch between default_zero and value (%s vs %s)" % [typeof(default_zero_), typeof(value_)])
		return

	atom = atom_
	key = key_
	value = value_
	default_zero = default_zero_

func execute() -> Array[StateChange]:
	if not atom:
		push_error("Operation cannot be executed: atom is null")
		return []

	var value_before = atom.get_state(key, default_zero)

	atom.set_state(key, value)

	return [StateChange.changed(atom, key, value_before)]
