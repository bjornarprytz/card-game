class_name Shuffle
extends Operation

var _zone: Zone = null

func _init(zone_: Zone) -> void:
    _zone = zone_

func execute() -> Array[StateChange]:
    var shuffled_atoms = _zone.atoms.duplicate()

    shuffled_atoms.shuffle()

    return SetState.new(_zone, "atoms", shuffled_atoms, []).execute()