extends Node

func create_operation_tree(keyword: String, args: Array[Variant]) -> KeywordNode:
    var tree = self.callv(keyword, args)
    return KeywordNode.create(keyword, args, tree)

func steel_attack(source: Creature, target: Creature, amount: int) -> Array[KeywordNode]:
    var sub_nodes: Array[KeywordNode] = []
    if amount <= 0:
        push_warning("Attack amount must be greater than 0. Returning noop.")
        return sub_nodes
    
    sub_nodes.append(create_operation_tree("deal_damage", [target, amount]))
    sub_nodes.append(create_operation_tree("add_armor", [source, amount]))
    
    return sub_nodes

func deal_damage(target: Creature, amount: int) -> Array[Operation]:
    var operations: Array[Operation] = []
    
    if amount <= 0:
        push_warning("Damage amount must be greater than 0. Returning noop.")
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

func add_armor(target: Creature, amount: int) -> Array[Operation]:
    var operations: Array[Operation] = []
    if amount <= 0:
        push_warning("Armor amount must be greater than 0. Returning noop.")
        return operations

    var new_total_armor = target.armor + amount

    operations.append(SetState.new(target, "armor", new_total_armor, 0))
    return operations

func create_creature(game_state: GameState, creature_name: String, zone: Zone) -> Array[Operation]:
    var operations: Array[Operation] = []
    operations.append(CreateAtom.new(game_state, creature_name, "creature", zone))
    return operations

func create_card(game_state: GameState, card_name: String, zone: Zone) -> Array[Operation]:
    var operations: Array[Operation] = []
    operations.append(CreateAtom.new(game_state, card_name, "card", zone))
    return operations
