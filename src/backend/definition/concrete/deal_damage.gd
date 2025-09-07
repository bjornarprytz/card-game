class_name DealDamageDefinition
extends KeywordDefinition

static var KEYWORD: String = &"deal_damage"

func _get_keyword() -> String:
	return KEYWORD

func deal_damage(target: Creature, amount: int) -> Array[Operation]:
	var operations: Array[Operation] = []
	
	if amount <= 0:
		push_warning("Damage amount must be greater than 0. Was %d. Returning noop." % amount)
		return operations

	var current_armor = target.armor
	var remaining_damage = amount
	if current_armor > 0:
		var remaining_armor = max(current_armor - remaining_damage, 0)
		operations.append(SetState.new(target, "armor", remaining_armor, 0))
		remaining_damage -= current_armor

	if remaining_damage > 0:
		var current_damage_taken = target.get_state("damage_taken", 0)
		var total_damage_taken = current_damage_taken + remaining_damage
		operations.append(SetState.new(target, "damage_taken", total_damage_taken, 0))

	return operations
