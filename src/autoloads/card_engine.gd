class_name CardEngine
extends Node2D

var _cards: Dictionary[String, Variant] = {}

var _atoms: Dictionary[String, Atom] = {}

func _ready() -> void:
	for card in Cards.load_card_data():
		add_card(card)

func add_atom() -> Atom:
	var atom = preload("res://atom.tscn").instantiate() as Atom
	atom.id = OS.get_unique_id()
	print(atom.id)
	add_child(atom)
	_atoms[atom.id] = atom
	
	return atom

func get_atom(id: String) -> Atom:
	if (!_atoms.has(id)):
		return null
	return _atoms[id]

func add_card(card: Variant):
	_cards[card.name] = card

func get_card(id: String) -> Variant:
	if (!_cards.has(id)):
		return null
	return _cards[id]

func get_cards() -> Array[Variant]:
	return _cards.values()
