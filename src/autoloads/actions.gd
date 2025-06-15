extends Node

signal keyword_resolved(keyword: String, args: Array[Variant])

func play_card(context: PlayCardContext) -> bool:
	var chosen_targets = context.chosen_targets
	var required_targets = context.card.card_data.targets
	var effects = context.card.card_data.effects
	
	if (chosen_targets.size() != required_targets.size()):
		return false
	
	for effect in effects:
		# Only execute the effect if its condition is satisfied
		if effect.evaluate_condition(context):
			var args = effect.resolve_args(context)
			
			Keywords.callv(effect.keyword, args)
			keyword_resolved.emit(effect.keyword, args)
	
	return true
