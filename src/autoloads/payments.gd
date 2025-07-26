extends Node


func verify(keyword: String,
	args: Array[Variant]
) -> PaymentResult:
	if (!self.has_method(keyword)):
		push_error("Method '%s' does not exist in %s" % [keyword, self.name])
		return null

	if (!self.get_method_argument_count(keyword) == args.size()):
		push_error("Method '%s' called with incorrect number of arguments in %s" % [keyword, self.name])
		return null
	
	var result = self.callv(keyword, args)

	if result == null:
		push_error("Method '%s' returned null in %s" % [keyword, self.name])
		return null

	return result

func pay_resources(state: GameState, amount: int) -> PaymentResult:
	assert(state.player.resources >= 0, "Player resources should not be negative")
	
	if state.player.resources < amount:
		push_warning("Not enough resources to pay %d, current resources: %d" % [amount, state.player.resources])
		return PaymentResult.failure()

	return PaymentResult.success(
		Keywords.create_operation_tree("lose_resources", [state.player, amount])
	)

func pay_discard(state: GameState, card: Atom) -> PaymentResult:
	assert(card != null, "Card to discard should not be null")
	
	if not card in state.hand.atoms:
		push_warning("Card %s is not in player's hand" % card.name)
		return PaymentResult.failure()

	return PaymentResult.success(
		Keywords.create_operation_tree("discard_card", [state, card])
	)
