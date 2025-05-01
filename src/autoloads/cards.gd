extends Node


func load_card_data() -> Array[CardData]:
	return [
		CardData.new(
			"Lightning Bolt",
			lightning_bolt,
			"Deal 3 damage to a target.",
		)
	]


func lightning_bolt(play_context: PlayContext):
	Keywords.deal_damage(play_context.chosen_targets[0].atom, 3)
