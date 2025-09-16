class_name SetupStepDefinition
extends KeywordDefinition

static var KEYWORD: String = &"setup_step"

func _get_keyword() -> String:
    return KEYWORD

func setup_step(initial_conditions: InitialGameState) -> Array[KeywordNode]:
    var operations: Array[KeywordNode] = []
    operations.append(
        _op_node(
            [SetState.new(_game_state.player, "lives", initial_conditions.starting_lives, 0)],
            [initial_conditions]
        )
    )

    for card_name in initial_conditions.deck:
        operations.append(_kw_node(CreateCardDefinition.KEYWORD, [card_name, _game_state.draw_pile]))

    for creature_name in initial_conditions.enemies:
        operations.append(_kw_node(CreateCreatureDefinition.KEYWORD, [creature_name, _game_state.battlefield]))

    return operations
