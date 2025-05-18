class_name CardEngine
extends Node2D

var _cards: Dictionary[String, CardProto] = {}

var _atoms: Dictionary[String, Atom] = {}

func _ready() -> void:
	for card in DataLoader.load_game_data().cards:
		add_card(card)

func add_atom() -> Atom:
	var atom = preload("res://state/atom.tscn").instantiate() as Atom
	atom.id = OS.get_unique_id()
	print(atom.id)
	add_child(atom)
	_atoms[atom.id] = atom
	
	return atom

func get_atom(id: String) -> Atom:
	if (!_atoms.has(id)):
		return null
	return _atoms[id]

func add_card(card: CardProto):
	_cards[card.name] = card

func get_card(id: String) -> CardProto:
	if (!_cards.has(id)):
		return null
	return _cards[id]

func get_cards() -> Array[CardProto]:
	return _cards.values()
