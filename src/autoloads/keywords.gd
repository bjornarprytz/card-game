extends Node

func resolve(context: PlayContext):
	for effect in context.card.effects:
		var target = context.chosen_targets[effect.target].atom
		var args = [target]
		args.append_array(effect.parameters)
		
		self.callv(effect.keyword, args)

func damage(target: Atom, amount: int):
	target.armor -= amount
	
	if (target.armor < 0):
		target.health += target.armor
		target.armor = 0

func add_armor(target: Atom, amount: int):
	target.armor += amount
