extends Node

func play_card(context: PlayContext) -> bool:
	print("Resolving card <%s>" % context.card.name)
	
	var chosen_targets = context.targets
	var required_targets = context.card.targets
	var effects = context.card.effects
	
	if (chosen_targets.size() != required_targets.size()):
		return false
	
	for effect in effects:
		var target = chosen_targets[effect.target]
		var args = [target]
		
		for param in effect.parameters:
			args.append(param.get_value(context))
		
		Keywords.callv(effect.keyword, args)
		print("resolved %s (%s)" % [effect.keyword, args])
	
	return true
