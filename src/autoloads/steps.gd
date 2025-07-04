extends Node

func create_operation_tree(step: String, game_state: GameState, extra_args: Array[Variant] = []) -> KeywordNode:
	if !self.has_method(step):
		push_error("Step <%s> does not exist in Steps" % step)
		return null

	var args: Array[Variant] = [game_state]
	args.append_array(extra_args)
	
	if !self.get_method_argument_count(step) == args.size():
		push_error("Step <%s> called with incorrect number of arguments in Steps" % step)
		return null
	
	var tree = self.callv(step, args)

	if tree == null:
		push_error("Method <%s> returned null in Steps" % step)
		return null

	return KeywordNode.create(step, args, tree)

func setup(game_state: GameState, initial_conditions: InitialGameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(SetState.new(game_state.player, "lives", initial_conditions.starting_lives, 0))

	for card_name in initial_conditions.deck:
		operations.append_array(Keywords.create_card(game_state, card_name, game_state.draw_pile))
	
	for creature_name in initial_conditions.enemies:
		operations.append_array(Keywords.create_creature(game_state, creature_name, game_state.battlefield))

	return operations

func upkeep(game_state: GameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append_array(Keywords.draw_cards(game_state, game_state.player.starting_hand_size))
	operations.append(SetState.new(game_state.player, "resources", game_state.player.starting_resources, 0))

	return operations

func end(game_state: GameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(Keywords.discard_hand(game_state))
	return operations

func cleanup(game_state: GameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	push_warning("Cleanup step is not implemented yet, returning empty operations. This should run after each action to reset the game state. Remove dead creatures, reset resources, etc.")
	return operations
