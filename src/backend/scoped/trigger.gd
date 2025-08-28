class_name Trigger
extends StaticEffect

var condition: ContextConditionProto = null
var effects: Array[EffectProto] = []

var trigger_limit: int = 0

func _init(condition_: ContextConditionProto, effects_: Array[EffectProto]) -> void:
	condition = condition_
	effects = effects_

func _to_string() -> String:
	return "When: %s, Do: %s" % [condition, effects]
