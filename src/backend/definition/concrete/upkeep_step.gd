class_name UpkeepStepDefinition
extends KeywordDefinition

static var KEYWORD: String = &"upkeep_step"

func _get_keyword() -> String:
    return KEYWORD

func upkeep_step() -> Array[KeywordNode]:
    var operations: Array[KeywordNode] = []
    operations.append(_kw_node(DrawCardsDefinition.KEYWORD, [_game_state.player.starting_hand_size]))
    operations.append(_op_node([SetState.new(_game_state.player, "resources", _game_state.player.starting_resources, 0)], []))
    return operations
