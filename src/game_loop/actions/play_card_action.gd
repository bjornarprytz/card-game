class_name PlayCardAction
extends GameAction

var _context: PlayCardContext

func _init(play_card_context: PlayCardContext) -> void:
	assert(play_card_context != null, "PlayCardContext cannot be null")
	action_type = "play_card"
	_context = play_card_context
	context = play_card_context

func _get_effects() -> Array[EffectProto]:
	return _context.card.card_data.effects
