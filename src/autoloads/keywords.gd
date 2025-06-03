extends Node

func damage(target: Creature, amount: int):
	target.armor -= amount
	
	if (target.armor < 0):
		target.health += target.armor
		target.armor = 0

func add_armor(target: Creature, amount: int):
	target.armor += amount
