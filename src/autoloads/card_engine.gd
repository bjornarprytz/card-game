class_name CardEngine
extends Node2D

class Card:
	var id : String
	
	func _init(id_ : String) -> void:
		id = id_

var _cards : Dictionary[String, Card] = {}

func add_card(card: Card):
	_cards[card.id] = card

func get_card(id: String) -> Card:
	if (!_cards.has(id)):
		return null
	return _cards[id]


func play(card: Card, target: Target):
	print("Playing %s on %s" % [card.id, target.name])
