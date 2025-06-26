class_name TransferAtom
extends Operation

var _from: Zone = null
var _to: Zone = null

func _init(from_: Zone, to_: Zone) -> void:
    _from = from_
    _to = to_

func execute() -> Array[StateChange]:
    if _from == null or _to == null:
        push_error("TransferAtom: _from or _to is null")
        return []

    var from_atoms = _from.get_atoms()
    if from_atoms.is_empty():
        push_warning("TransferAtom: No atoms to transfer from _from zone")
        return []

    var atom = from_atoms.pop_front()

    var change_zone = ChangeZone.new(atom, _to)

    return change_zone.execute()