class_name PlayCardAction
extends GameAction

var _context: PlayCardContext

func _init(play_card_context: PlayCardContext) -> void:
	assert(play_card_context != null, "PlayCardContext cannot be null")
	action_type = "play_card"
	_context = play_card_context
	context = play_card_context

func get_prompt() -> PromptNode:
	var unanswered_prompts: Array[PromptBindingProto] = []

	for answer_key in _context.prompt.keys():
		for prompt in _context.card.card_data.prompts:
			if prompt.binding_key != answer_key:
				unanswered_prompts.append(prompt)

	if unanswered_prompts.size() == 0:
		push_warning("No unanswered prompts found for card: %s" % _context.card.name)
		return null
	
	return PromptNode.new(_context, unanswered_prompts)

func _get_effects() -> Array[EffectProto]:
	return _context.card.card_data.effects

func _get_costs() -> Array[CostProto]:
	return _context.card.card_data.cost
