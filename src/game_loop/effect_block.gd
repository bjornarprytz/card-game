class_name EffectBlock
extends Resource

var context: Context

func is_valid() -> bool:
	push_error("EffectBlock needs to be implemented in a subclass")
	return false

func has_next_keyword() -> bool:
	push_error("EffectBlock needs to be implemented in a subclass")
	return false

func next_keyword() -> KeywordNode:
	push_error("EffectBlock needs to be implemented in a subclass")
	return null

func _create_keyword_node(effect_proto: EffectProto) -> KeywordNode:
	# Evaluate the condition of the effect
	if not effect_proto.evaluate_condition(context):
		return KeywordNode.noop(effect_proto.keyword)
	
	# Resolve arguments for the effect
	var args = effect_proto.resolve_args(context)
	return Keywords.create_operation_tree(effect_proto.keyword, args)

func _to_string() -> String:
	push_error("EffectBlock needs to be implemented in a subclass")
	return "<EffectBlock>"
