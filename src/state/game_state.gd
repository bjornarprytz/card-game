class_name GameState
extends Node2D

# The strings are Atom IDs

var draw_pile: Array[String] = []

var discard_pile: Array[String] = []
var hand: Array[String] = []

var battlefield: Array[String] = []

var _atoms: Dictionary[String, Atom] = {}


func get_atom(id: String) -> Atom:
	if _atoms.has(id):
		return _atoms[id]
	else:
		push_error("Error: Atom with ID '%s' not found" % id)
		return null

static func from_dict(dict: Dictionary) -> GameState:
	var game_state = GameState.new()
	
	for card_name in dict["deck"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.draw_pile.append(atom.id)

	for card_name in dict["discard_pile"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.discard_pile.append(atom.id)

	for card_name in dict["hand"]:
		var atom = Create.card(card_name)
		game_state._atoms[atom.id] = atom
		game_state.hand.append(atom.id)

	for creature_name in dict["battlefield"]:
		var atom = Create.creature(creature_name)
		game_state._atoms[atom.id] = atom
		game_state.battlefield.append(atom.id)

	return game_state
