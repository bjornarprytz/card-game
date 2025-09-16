class_name DiscardCardDefinition
extends KeywordDefinition

static var KEYWORD: String = &"discard_card"

func _get_keyword() -> String:
    return KEYWORD

func discard_card(card: Atom) -> Array[Operation]:
    var operations: Array[Operation] = []

    if card.current_zone != _game_state.hand:
        push_warning("Card %s is not in hand, cannot discard." % card.name)
        return operations

    operations.append(ChangeZone.new(card, _game_state.discard_pile))
    return operations
