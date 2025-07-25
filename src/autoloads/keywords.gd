extends Node

func create_operation_tree(keyword: String, args: Array[Variant]) -> KeywordNode:
    if (!self.has_method(keyword)):
        push_error("Method '%s' does not exist in %s" % [keyword, self.name])
        return null

    if (!self.get_method_argument_count(keyword) == args.size()):
        push_error("Method '%s' called with incorrect number of arguments in %s" % [keyword, self.name])
        return null
    
    var tree = self.callv(keyword, args)

    if tree == null:
        push_error("Method '%s' returned null in %s" % [keyword, self.name])
        return null

    return KeywordNode.create(keyword, args, tree)

func prompt(_prompt_data: Variant) -> Array[Operation]:
    return [NoopOperation.new()]

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

func lose_resources(player: Player, amount: int) -> Array[Operation]:
    var operations: Array[Operation] = []
    if amount <= 0:
        push_warning("Resource loss amount must be greater than 0. Returning noop. Amount was: %d" % amount)
        return operations

    var new_resource_amount = player.resources - amount
    operations.append(SetState.new(player, "resources", new_resource_amount, 0))
    return operations

func create_creature(game_state: GameState, creature_name: String, zone: Zone) -> Array[Operation]:
    var operations: Array[Operation] = []
    operations.append(CreateAtom.new(game_state, creature_name, "creature", zone))
    return operations

func create_card(game_state: GameState, card_name: String, zone: Zone) -> Array[Operation]:
    var operations: Array[Operation] = []
    operations.append(CreateAtom.new(game_state, card_name, "card", zone))
    return operations

func draw_cards(game_state: GameState, count: int) -> Array[Operation]:
    var operations: Array[Operation] = []
    
    for i in range(count):
        operations.append(TransferAtom.new(game_state.draw_pile, game_state.hand))
        
    return operations

func discard_hand(game_state: GameState) -> Array[KeywordNode]:
    var sub_nodes: Array[KeywordNode] = []

    sub_nodes.append(create_operation_tree("discard_cards", [game_state, game_state.hand]))

    return sub_nodes

func discard_card(game_state: GameState, card: Atom) -> Array[Operation]:
    var operations: Array[Operation] = []

    if card.current_zone != game_state.hand:
        push_warning("Card %s is not in hand, cannot discard." % card.name)
        return operations

    operations.append(ChangeZone.new(card, game_state.discard_pile))
    return operations

func discard_cards(game_state: GameState, cards: Array[Atom]) -> Array[KeywordNode]:
    var sub_nodes: Array[KeywordNode] = []

    # Check unique cards
    var unique_cards: Array[Card] = []
    for card in cards:
        if not card is Card:
            push_error("Card %s is not a valid Card instance, skipping." % card)
            continue
        if card in unique_cards:
            push_error("Card %s is already queued for discard, skipping duplicate." % card)
            continue
        unique_cards.append(card)

    for card in unique_cards:
        sub_nodes.append(create_operation_tree("discard_card", [game_state, card]))

    return sub_nodes
