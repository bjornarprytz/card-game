class_name CreateCardDefinition
extends KeywordDefinition

static var KEYWORD: String = &"create_card"

func _get_keyword() -> String:
	return KEYWORD

func create_card(game_state: GameState, card_name: String, zone: Zone) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(CreateAtom.new(game_state, card_name, "card", zone))
	return operations
