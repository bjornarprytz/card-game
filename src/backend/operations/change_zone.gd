class_name ChangeZone
extends Operation

var atom: Atom
var zone: Zone

func _init(atom_: Atom, zone_: Zone) -> void:
	atom = atom_
	zone = zone_

func execute() -> Array[StateChange]:
	var current_zone = atom.current_zone

	if (current_zone == null and zone == null):
		push_error("Both current and new zones are null. This is probably a bug.")
		return []

	if (current_zone == zone):
		push_warning("Atom <%s> is already in zone <%s>. No change needed." % [atom.atom_name, zone.name])
		return []

	var operations: Array[Operation] = []

	if atom.current_zone != null:
		var current_zone_new_atoms = current_zone.atoms.duplicate()
		current_zone_new_atoms.remove_atom(atom)

		operations.append(SetState.new(current_zone, "atoms", current_zone_new_atoms, [] as Array[Atom]))

	operations.append(SetState.new(atom, "current_zone", zone, null))

	if zone != null:
		var new_zone_new_atoms = zone.atoms.duplicate()
		new_zone_new_atoms.append(atom)
		operations.append(SetState.new(zone, "atoms", new_zone_new_atoms, [] as Array[Atom]))

	var state_changes: Array[StateChange] = []

	for operation in operations:
		for state_change in operation.execute():
			state_changes.append(state_change)
	
	return state_changes
