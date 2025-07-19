class_name PlayCardContext
extends Context

var card: Card

static func create(state_: GameState, card_: Card, chosen_targets_: Array[Atom]) -> PlayCardContext:
	var context = PlayCardContext.new(state_)
	context.card = card_
	context.prompt["targets"] = chosen_targets_
	context.vars = card_.card_data.variables.duplicate()
	return context
