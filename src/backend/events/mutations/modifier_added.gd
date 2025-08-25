class_name ModifierAdded
extends Mutation

var modifier: Modifier

func _init(atom_: Atom, modifier_: Modifier) -> void:
	atom = atom_
	modifier = modifier_

func _to_string() -> String:
	return "%s~%s" % [atom, modifier]
