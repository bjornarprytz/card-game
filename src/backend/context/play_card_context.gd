class_name PlayCardContext
extends Context

var card: Card

static func create(state_: GameState, card_: Card) -> PlayCardContext:
	var context = PlayCardContext.new(state_, card_)
	context.card = card_
	context.vars.merge(card_.card_data.variables)
	return context
