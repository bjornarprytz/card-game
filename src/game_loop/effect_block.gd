class_name EffectBlock
extends Resource

var context: Context

func _init(context_: Context) -> void:
	context = context_

func is_valid() -> bool:
	push_error("EffectBlock needs to be implemented in a subclass")
	return false

func has_next_keyword() -> bool:
	push_error("EffectBlock needs to be implemented in a subclass")
	return false

func resolve_next_keyword() -> KeywordResult:
	if not has_next_keyword():
		push_error("No next keyword to resolve.")
		return null

	var keyword_node = _get_next_keyword()
	var result = keyword_node.resolve()

	context.scopes.add_result(result)

	return result

func _get_next_keyword() -> KeywordNode:
	push_error("EffectBlock needs to be implemented in a subclass")
	return null


func _to_string() -> String:
	push_error("EffectBlock needs to be implemented in a subclass")
	return "<EffectBlock>"
