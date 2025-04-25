class_name Keywords
extends Node


static func deal_damage(target: Target, amount: int):
	target.armor -= amount
	
	if (target.armor < 0):
		target.health += target.armor
		target.armor = 0

static func add_armor(target: Target, amount: int):
	target.armor += amount
