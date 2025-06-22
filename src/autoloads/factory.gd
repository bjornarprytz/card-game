class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton
var card_scene = preload("res://state/card.tscn")
var creature_scene = preload("res://state/creature.tscn")

func atom(atom_name: String, atom_type: String) -> Atom:
	match atom_type.to_lower():
		"card":
			return card(atom_name)
		"creature":
			return creature(atom_name)
		_:
			push_error("Unknown atom type: %s" % atom_type)
			return null


func card(card_name: String) -> Card:
	var node = card_scene.instantiate() as Card
	node.atom_name = card_name
	node.atom_type = "card"
	return node
	

func creature(creature_name: String) -> Creature:
	var node = creature_scene.instantiate() as Creature
	node.atom_name = creature_name
	node.atom_type = "creature"
	return node
