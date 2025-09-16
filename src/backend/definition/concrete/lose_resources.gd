class_name LoseResourcesDefinition
extends KeywordDefinition

static var KEYWORD: String = &"lose_resources"

func _get_keyword() -> String:
    return KEYWORD

func lose_resources(player: Player, amount: int) -> Array[Operation]:
    var operations: Array[Operation] = []
    if amount <= 0:
        push_warning("Resource loss amount must be greater than 0. Returning noop. Amount was: %d" % amount)
        return operations

    var new_resource_amount = player.resources - amount
    operations.append(SetState.new(player, "resources", new_resource_amount, 0))
    return operations
