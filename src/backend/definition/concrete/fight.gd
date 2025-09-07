class_name FightDefinition
extends KeywordDefinition

static var KEYWORD: String = &"fight"

func _get_keyword() -> String:
	return KEYWORD

func fight(c1: Creature, c2: Creature) -> Array[KeywordNode]:
	var sub_nodes: Array[KeywordNode] = []
	sub_nodes.append(_keyword_provider.create_operation_tree(AttackDefinition.KEYWORD, [c2, c1]))
	sub_nodes.append(_keyword_provider.create_operation_tree(AttackDefinition.KEYWORD, [c1, c2]))
	return sub_nodes
