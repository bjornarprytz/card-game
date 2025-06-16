class_name GameState
extends Node2D

@onready var draw_pile: Zone = $DrawPile
@onready var discard_pile: Zone = $DiscardPile
@onready var hand: Zone = $Hand
@onready var battlefield: Zone = $Battlefield
@onready var exile: Zone = $Exile

var _next_atom_id: int = 1
var _atoms: Dictionary[int, Atom] = {}

func _ready() -> void:
	# Ensure all zones are registered with the game state
	for zone in [draw_pile, discard_pile, hand, battlefield, exile]:
		ensure_registered(zone)

func ensure_registered(atom: Atom) -> int:
	if atom.id != 0:
		if !_atoms.has(atom.id):
			push_error("Atom with id <%d> is not previously registered. Where did it get its ID?" % atom.id)
			return -1
		return atom.id

	atom.id = _next_atom_id
	_next_atom_id += 1

	_atoms[atom.id] = atom
	return atom.id

func get_atom(id: int) -> Atom:
	if !_atoms.has(id):
		push_error("Trying to get non-existent atom with id <%d>" % id)
		return null
	
	return _atoms[id]

# TODO: This needs to happen in a game action instead of here.
static func from_dict(dict: Dictionary) -> GameState:
	var game_state = GameState.new()
	
	for card_name in dict["deck"]:
		var atom = Create.card(card_name)
		game_state.draw_pile.add_atom(atom)

	for card_name in dict["discard_pile"]:
		var atom = Create.card(card_name)
		game_state.discard_pile.add_atom(atom)

	for card_name in dict["hand"]:
		var atom = Create.card(card_name)
		game_state.hand.add_atom(atom)

	for creature_name in dict["battlefield"]:
		var atom = Create.creature(creature_name)
		game_state.battlefield.add_atom(atom)

	return game_state
