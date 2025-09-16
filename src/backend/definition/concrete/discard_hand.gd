class_name DiscardHandDefinition
extends KeywordDefinition

static var KEYWORD: String = &"discard_hand"

func _get_keyword() -> String:
    return KEYWORD

func discard_hand() -> Array[KeywordNode]:
    var sub_nodes: Array[KeywordNode] = []

    sub_nodes.append(_kw_node(DiscardCardsDefinition.KEYWORD, [_game_state.hand.atoms]))

    return sub_nodes
