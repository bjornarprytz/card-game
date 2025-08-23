class_name TriggerBlock
extends EffectBlock

var _context: TriggerContext

var _effect_index: int = 0

func _init(context_: TriggerContext) -> void:
	assert(context_.prompt.is_empty(), "Trigger blocks shouldn't have prompts. At least I'd need to think about it first.")

	super._init(context_)
	_context = context_

func try_verify_and_prepare() -> bool:
	return true

func has_next_keyword() -> bool:
	return _effect_index < _context.trigger.trigger.effects.size()

func _get_next_keyword() -> KeywordNode:
	if !has_next_keyword():
		push_error("No next keyword to get.")
		return null

	var keyword_node = _context.trigger.trigger.effects[_effect_index].create_operation_tree(_context)
	_effect_index += 1
	return keyword_node

func _to_string() -> String:
	return "Trigger context: %s" % _context.to_string()
