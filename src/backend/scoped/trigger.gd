class_name Trigger
extends StaticEffect

var condition: ContextConditionProto = null
var effects: Array[EffectProto] = []

## The maximum number of times this trigger can activate. 0 means unlimited
var trigger_limit: int = 0

func _init(condition_: ContextConditionProto, effects_: Array[EffectProto], trigger_limit_: int = 0) -> void:
	condition = condition_
	effects = effects_
	trigger_limit = trigger_limit_

func _to_string() -> String:
	return "When: %s, Do: %s" % [condition, effects]
