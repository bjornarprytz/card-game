class_name GameState
extends Node2D

var draw_pile: Array[Card] = []

var discard_pile: Array[Card] = []
var hand: Array[Card] = []

var battlefield: Array[Creature] = []

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
		game_state.draw_pile.append(atom)

	for card_name in dict["discard_pile"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.discard_pile.append(atom)

	for card_name in dict["hand"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.hand.append(atom)

	for creature_name in dict["battlefield"]:
		var atom = Create.creature(creature_name)
		game_state._atoms[atom.id] = atom
		game_state.battlefield.append(atom)

	return game_state
