class_name GameState
extends Node2D

## TODO: Remove all this nonsense and instanitate nodes for everything
## Keep get_atom, but atoms should be reparented when they change zone

var draw_pile: Array[int] = []

var discard_pile: Array[int] = []
var hand: Array[int] = []

var battlefield: Array[int] = []

var _atoms: Dictionary[int, Atom] = {}

func get_atom(id: int) -> Atom:
	if !_atoms.has(id):
		push_error("Trying to get non-existent atom with id <%d>" % id)
		return null
	
	return _atoms[id]

static func from_dict(dict: Dictionary) -> GameState:
	var game_state = GameState.new()
	
	for card_name in dict["deck"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.draw_pile.append(atom.id)
		game_state.add_child(atom)

	for card_name in dict["discard_pile"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.discard_pile.append(atom.id)
		game_state.add_child(atom)

	for card_name in dict["hand"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.hand.append(atom.id)
		game_state.add_child(atom)

	for creature_name in dict["battlefield"]:
		var atom = Create.creature(creature_name)
		game_state._atoms[atom.id] = atom
		game_state.battlefield.append(atom.id)
		game_state.add_child(atom)

	return game_state
