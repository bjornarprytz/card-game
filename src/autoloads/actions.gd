extends Node

signal action_resolved(context: Context)

func play_card(context: PlayCardContext) -> bool:   
	var chosen_targets = context.chosen_targets
	var required_targets = context.card.card_data.targets
	var effects = context.card.card_data.effects
	
	if (chosen_targets.size() != required_targets.size()):
		return false
	
	for effect in effects:
		var target = chosen_targets[effect.target]
		var args = [target]
		
		for param in effect.parameters:
			args.append(param.get_value(context))
		
		Keywords.callv(effect.keyword, args)
	
	return true


func _resolve_context(context: Context) -> bool:
	if (context.card == null):
		print("No card to resolve")
		return false
	
	if (context.targets.size() == 0):
		print("No targets selected")
		return false
	
	if (play_card(context)):
		print("Card <%s> played successfully" % context.card.name)
		return true
	else:
		print("Failed to play card <%s>" % context.card.name)
		return false
