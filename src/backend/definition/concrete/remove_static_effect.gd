class_name RemoveStaticEffectDefinition
extends KeywordDefinition

static var KEYWORD: String = &"remove_static_effect"

func _get_keyword() -> String:
	return KEYWORD

func remove_static_effect(handle: StaticEffectHandle) -> Array[Operation]:
	return [RemoveStaticEffect.new(handle)]
