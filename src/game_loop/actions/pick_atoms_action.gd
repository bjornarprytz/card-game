class_name PickAtomsAction
extends GameAction

var _selected_atoms: Array[Atom] = []

func _init(selected_atoms_: Array[Atom]):
    action_type = "pick_atoms"
    _selected_atoms = selected_atoms_

func get_selected_atoms() -> Array[Atom]:
    return _selected_atoms
