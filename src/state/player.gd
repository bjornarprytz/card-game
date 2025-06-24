class_name Player
extends Atom

var resources: int:
	get:
		return get_state("resources", 0)

var lives: int:
	get:
		return get_state("lives", 0)


var starting_lives: int:
	get:
		return get_property("starting_lives", 20)

var starting_resources: int:
	get:
		return get_property("starting_resources", 3)

var starting_hand_size: int:
	get:
		return get_property("starting_hand_size", 5)
