class_name InitialGameState
extends Resource

var starting_lives: int
var deck: Array[String] = []
var enemies: Array[String] = []


static func from_dict(dict: Dictionary) -> InitialGameState:
	var initial_state = InitialGameState.new()
	
	initial_state.starting_lives = dict.get("starting_lives", 20)
	
	for card_name in dict.get("deck", []):
		if card_name is String:
			initial_state.deck.append(card_name)
		else:
			push_error("Invalid card in deck: %s" % str(card_name))
	
	for enemy_name in dict.get("enemies", []):
		if enemy_name is String:
			initial_state.enemies.append(enemy_name)
		else:
			push_error("Invalid enemy in enemies: %s" % str(enemy_name))

	return initial_state
