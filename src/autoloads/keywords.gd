extends Node

func resolve(context: PlayContext):
	for effect in context.card.effects:
		var target = context.targets[effect.target].atom
		var args = [target]
		
		for param in effect.parameters:
			args.append(param.get_value(context))
		
		self.callv(effect.keyword, args)
		print("resolved %s (%s)" % [effect.keyword, args])

func damage(target: Creature, amount: int):
	target.armor -= amount
	
	if (target.armor < 0):
		target.health += target.armor
		target.armor = 0

func add_armor(target: Creature, amount: int):
	target.armor += amount
