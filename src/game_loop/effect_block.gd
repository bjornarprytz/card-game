class_name EffectBlock
extends Resource

func has_next_keyword() -> bool:
    push_error("EffectBlock needs to be implemented in a subclass")
    return false

func next_keyword() -> KeywordNode:
    push_error("EffectBlock needs to be implemented in a subclass")
    return null

