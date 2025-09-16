class_name EndStepDefinition
extends StepDefinition

static var KEYWORD: String = &"end_step"

func _get_keyword() -> String:
    return KEYWORD

func end_step() -> Array[Operation]:
    var operations: Array[Operation] = []
    operations.append(Keywords.discard_hand(_game_state))
    return operations
