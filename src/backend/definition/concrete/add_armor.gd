class_name AddArmorDefinition
extends KeywordDefinition

static var KEYWORD: String = &"add_armor"

func _get_keyword() -> String:
	return KEYWORD

func add_armor(target: Creature, amount: int) -> Array[Operation]:
	var operations: Array[Operation] = []
	if amount <= 0:
		push_warning("Armor amount must be greater than 0. Returning noop.")
		return operations

	var new_total_armor = target.armor + amount
	operations.append(SetState.new(target, "armor", new_total_armor, 0))
	return operations
