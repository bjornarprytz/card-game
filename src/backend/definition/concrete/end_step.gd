class_name EndStepDefinition
extends KeywordDefinition

static var KEYWORD: String = &"end_step"

func _get_keyword() -> String:
    return KEYWORD

func end_step() -> Array[KeywordNode]:
    var operations: Array[KeywordNode] = []
    operations.append(_kw_node(DiscardHandDefinition.KEYWORD))
    return operations
