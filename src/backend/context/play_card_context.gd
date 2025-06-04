class_name PlayCardContext
extends Context

var card: Card
var chosen_targets: Array[Atom] = []

static func create(state_: GameState, card_: Card, chosen_targets_: Array[Atom]) -> PlayCardContext:
	var context = PlayCardContext.new()
	context.card = card_
	context.state = state_
	context.chosen_targets = chosen_targets_
	context.vars = card_.card_data.variables.duplicate()
	return context
