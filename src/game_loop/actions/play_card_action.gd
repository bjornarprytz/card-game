class_name PlayCardAction
extends GameAction

var _context: PlayCardContext

var _effect_index: int = 0

func _init(play_card_context: PlayCardContext) -> void:
	assert(play_card_context != null, "PlayCardContext cannot be null")
	_context = play_card_context

func pop_next_operation_tree() -> KeywordNode:
	assert(!is_finished(), "PlayCardAction is already finished")
	
	var card = _context.card.card_data
	var effect = card.effects[_effect_index]
	_effect_index += 1

	var args = effect.resolve_args(_context)

	var operation_tree = Keywords.create_operation_tree(effect.keyword, args)
	
	return operation_tree

func is_finished() -> bool:
	return _effect_index >= _context.card.card_data.effects.size()

func _to_string() -> String:
	# Returns a string representation of the action
	return "PlayCardAction: %s" % _context.card.card_data.name
