class_name SetupStepDefinition
extends StepDefinition

static var KEYWORD: String = &"setup_step"

func _get_keyword() -> String:
	return KEYWORD

func setup_step(initial_conditions: InitialGameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(SetState.new(_game_state.player, "lives", initial_conditions.starting_lives, 0))

	for card_name in initial_conditions.deck:
		operations.append_array(Keywords.create_card(_game_state, card_name, _game_state.draw_pile))
	
	for creature_name in initial_conditions.enemies:
		operations.append_array(Keywords.create_creature(_game_state, creature_name, _game_state.battlefield))

	return operations
