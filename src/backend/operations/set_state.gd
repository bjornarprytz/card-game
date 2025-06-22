class_name SetState
extends Operation

var atom: Atom
var key: String
var value: Variant

func _init(atom_: Atom, key_: String, value_: Variant) -> void:
    atom = atom_
    key = key_
    value = value_

func execute() -> Array[StateChange]:
    if not atom:
        push_error("Operation cannot be executed: atom is null")
        return []

    var value_before = atom.get_state(key, null)

    atom.set_state(key, value)

    return [StateChange.changed(atom, key, value_before)]