class_name DrawCardsDefinition
extends KeywordDefinition

static var KEYWORD: String = &"draw_cards"

func _get_keyword() -> String:
    return KEYWORD

func draw_cards(count: int) -> Array[Operation]:
    var operations: Array[Operation] = []
    for i in range(count):
        operations.append(TransferAtom.new(_game_state.draw_pile, _game_state.hand))
    return operations
