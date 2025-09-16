class_name DiscardCardsDefinition
extends KeywordDefinition

static var KEYWORD: String = &"discard_cards"

func _get_keyword() -> String:
    return KEYWORD

func discard_cards(cards: Array[Atom]) -> Array[KeywordNode]:
    var sub_nodes: Array[KeywordNode] = []

    # Check unique cards
    var unique_cards: Array[Card] = []
    for card in cards:
        if not card is Card:
            push_error("Card %s is not a valid Card instance, skipping." % card)
            continue
        if card in unique_cards:
            push_error("Card %s is already queued for discard, skipping duplicate." % card)
            continue
        unique_cards.append(card)

    for card in unique_cards:
        sub_nodes.append(_kw_node(DiscardCardDefinition.KEYWORD, [card]))

    return sub_nodes
