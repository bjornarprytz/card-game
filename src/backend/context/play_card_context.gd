class_name PlayCardContext
extends Context

var card: Card

static func create(state_: GameState, card_: Card, prompt_answers: Dictionary[String, Variant]) -> PlayCardContext:
	var context = PlayCardContext.new(state_)
	context.card = card_
	context.prompt = prompt_answers.duplicate() ## TODO: Make sure they're verified
	context.vars = card_.card_data.variables.duplicate()
	return context
