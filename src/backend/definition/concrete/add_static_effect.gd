class_name AddStaticEffectDefinition
extends KeywordDefinition

static var KEYWORD: String = &"add_static_effect"

func _get_keyword() -> String:
	return KEYWORD

func add_static_effect(handle: StaticEffectHandle) -> Array[Operation]:
	return [CreateStaticEffect.new(handle)]
