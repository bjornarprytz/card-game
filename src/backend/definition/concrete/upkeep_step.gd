class_name UpkeepStepDefinition
extends StepDefinition

static var KEYWORD: String = &"upkeep_step"

func _get_keyword() -> String:
	return KEYWORD

func upkeep_step() -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append_array(Keywords.draw_cards(_game_state, _game_state.player.starting_hand_size))
	operations.append(SetState.new(_game_state.player, "resources", _game_state.player.starting_resources, 0))
	return operations
