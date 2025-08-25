class_name AtomCreated
extends Mutation


func _init(atom_: Atom = null) -> void:
	atom = atom_

func _to_string() -> String:
	return "%s Created!" % [atom]
