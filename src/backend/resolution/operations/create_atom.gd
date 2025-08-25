class_name CreateAtom
extends Operation

var game_state: GameState
var atom_name: String
var atom_type: String
var zone: Zone

func _init(game_state_: GameState, atom_name_: String, atom_type_: String, zone_: Zone) -> void:
	game_state = game_state_
	atom_name = atom_name_
	atom_type = atom_type_
	zone = zone_

func execute() -> Array[Mutation]:
	var atom = Create.atom(atom_name, atom_type)

	game_state.register_atom(atom)

	var mutations: Array[Mutation] = [Mutation.created(atom)]

	for mutation in ChangeZone.new(atom, zone).execute():
		mutations.append(mutation)

	return mutations
