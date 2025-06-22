extends Node

func deal_damage(target: Creature, amount: int) -> KeywordNode:
	if amount <= 0:
		push_warning("Damage amount must be greater than 0. Returning noop.")
		return KeywordNode.noop("deal_damage", [target, amount])
	var operations: Array[Operation] = []

	var current_armor = target.armor
	var remaining_damage = amount
	if current_armor > 0:
		var remaining_armor = max(current_armor - remaining_damage, 0)
		operations.append(SetState.new(target, "armor", remaining_armor))
		remaining_damage -= current_armor

	if remaining_damage > 0:
		var current_damage_taken = target.get_state("damage_taken", 0)
		var total_damage_taken = current_damage_taken + remaining_damage
		operations.append(SetState.new(target, "damage_taken", total_damage_taken))

	return KeywordNode.terminal("deal_damage", [target, amount], operations)

func add_armor(target: Creature, amount: int) -> KeywordNode:
	if amount <= 0:
		push_warning("Armor amount must be greater than 0. Returning noop.")
		return KeywordNode.noop("add_armor", [target, amount])

	var new_total_armor = target.armor + amount

	return KeywordNode.terminal("add_armor", [target, amount], [SetState.new(target, "armor", new_total_armor)])

func create_creature(game_state: GameState, creature_name: String, zone: Zone) -> KeywordNode:
	return KeywordNode.composite(
		"create_creature", 
		[game_state, creature_name, zone], 
		[create_atom(game_state, creature_name, "creature", zone)]
		)

func create_card(game_state: GameState, card_name: String, zone: Zone) -> KeywordNode:
	return KeywordNode.composite(
		"create_card", 
		[game_state, card_name, zone], 
		[create_atom(game_state, card_name, "card", zone)]
		)

func create_atom(game_state: GameState, atom_name: String, atom_type: String, zone: Zone) -> KeywordNode:
	return KeywordNode.terminal(
		"create_atom", 
		[game_state, atom_name, atom_type, zone], 
		[CreateAtom.new(game_state, atom_name, atom_type, zone)]
		)
