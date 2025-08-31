class_name TriggerProto
extends StaticEffectProto

var trigger_condition: ContextConditionProto
var effects: Array[EffectProto] = []

var trigger_limit: int = 0

func _create_handle(context: Context) -> StaticEffectHandle:
	var trigger = Trigger.new(trigger_condition, effects, trigger_limit)
	var resolved_host = _get_host(context)
	var resolved_scope = _get_scope(context)

	return TriggerHandle.new(trigger, resolved_scope, resolved_host)

static func from_dict(data: Dictionary) -> TriggerProto:
	var trigger = TriggerProto.new()

	var trigger_data = data.get("add_trigger", {})

	trigger.trigger_condition = ContextConditionProto.from_strings(trigger_data.get("conditions", []))

	if trigger.trigger_condition.expressions.is_empty():
		push_error("Error: TriggerProto conditions are missing or empty. Triggers need at least one condition.")
		return null

	for effect_data in trigger_data.get("effects", []):
		var effect = EffectProto.from_dict(effect_data)
		if effect:
			trigger.effects.append(effect)

	trigger.scope = StaticEffectProto.parse_scope_level(trigger_data.get("scope", "GLOBAL"))

	var target_shorthand = data.get("target", null)
	if (target_shorthand != null):
		trigger.host = ContextExpression.from_string(target_shorthand)
	else:
		trigger.host = ContextExpression.from_string(data.get("host", null))

	trigger.turn_duration = trigger_data.get("turn_duration", 0)
	trigger.trigger_limit = trigger_data.get("trigger_limit", 0)

	return trigger
