class_name AttackDefinition
extends KeywordDefinition

static var KEYWORD: String = &"attack"

func _get_keyword() -> String:
    return KEYWORD

func attack(source: Creature, target: Creature) -> Array[KeywordNode]:
    var sub_nodes: Array[KeywordNode] = []

    sub_nodes.append(_kw_node(DealDamageDefinition.KEYWORD, [target, source.attack]))

    return sub_nodes
