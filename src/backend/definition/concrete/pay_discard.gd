class_name PayDiscardDefinition
extends PaymentDefinition

static var KEYWORD: String = &"pay_discard"

func _get_keyword() -> String:
	return KEYWORD

func pay_discard(card: Atom) -> PaymentResult:
	assert(card != null, "Card to discard should not be null")

	if not card in _game_state.hand.atoms:
		push_warning("Card %s is not in player's hand" % card.name)
		return PaymentResult.failure()

	return PaymentResult.success(
		_kw_node(DiscardCardDefinition.KEYWORD, [card])
	)
