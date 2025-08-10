class_name EffectBlock
extends Resource

var context: Context

## Return unanswered prompts
func get_prompt() -> PromptNode:
	return null

func has_next_keyword() -> bool:
	push_error("EffectBlock needs to be implemented in a subclass")
	return false

func next_keyword() -> KeywordNode:
	push_error("EffectBlock needs to be implemented in a subclass")
	return null

func _to_string() -> String:
	push_error("EffectBlock needs to be implemented in a subclass")
	return "<EffectBlock>"
