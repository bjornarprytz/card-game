class_name PickAtomsAction
extends GameAction

var selected_atoms: Array[Atom] = []

func _init(selected_atoms_: Array[Atom]):
    action_type = "pick_atoms"
    selected_atoms = selected_atoms_

func get_selected_atoms() -> Array[Atom]:
    return selected_atoms
