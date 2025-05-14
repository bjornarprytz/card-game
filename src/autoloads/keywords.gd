extends Node

func resolve(context: PlayContext):
	for effect in context.card.effects:
		var target = context.targets[effect.target].atom
		var args = [target]
		
		for param in effect.parameters:
			args.append(param.get_value(context))
		
		self.callv(effect.keyword, args)

func damage(target: Atom, amount: int):
	target.armor -= amount
	
	if (target.armor < 0):
		target.health += target.armor
		target.armor = 0

func add_armor(target: Atom, amount: int):
	target.armor += amount
