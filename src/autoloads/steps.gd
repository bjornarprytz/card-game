extends Node

func create_operation_tree(step: String, game_state: GameState) -> KeywordNode:
	var args: Array[Variant] = [game_state]
	var tree = self.callv(step, args)
	return KeywordNode.create(step, args, tree)

func setup(game_state: GameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(SetState.new(game_state.player, "lives", game_state.player.starting_lives, 0))
	operations.append(SetState.new(game_state.player, "resources", game_state.player.starting_resources, 0))
	return operations

func upkeep(game_state: GameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append_array(Keywords.draw_cards(game_state, game_state.player.starting_hand_size))
	return operations

func end(game_state: GameState) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(Keywords.discard_hand(game_state))
	return operations
