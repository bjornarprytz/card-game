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
