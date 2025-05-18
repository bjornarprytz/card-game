class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton
var card_scene = preload("res://state/card.tscn")
var creature_scene = preload("res://state/creature.tscn")


func card(card_name: String) -> Card:
	var node = card_scene.instantiate() as Card
	node.card_name = card_name
	return node
	

func creature(creature_name: String) -> Creature:
	var node = creature_scene.instantiate() as Creature
	node.creature_name = creature_name
	return node
