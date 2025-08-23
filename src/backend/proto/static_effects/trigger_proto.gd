class_name TriggerProto
extends StaticEffectProto

var trigger_condition: ContextConditionProto
var effects: Array[EffectProto] = []

func _init() -> void:
	keyword = "add_trigger"

func _resolve_args(context: Context) -> Array:
	var args = []

	var trigger = Trigger.new(trigger_condition, effects)
	args.append(trigger)
	var source_atom = source.evaluate(context)
	assert(source_atom is Atom, "Source must be an Atom")
	args.append(source_atom)

	var trigger_scope: Scope
	match scope:
		ScopeLevel.BLOCK:
			trigger_scope = context.scopes.block
		ScopeLevel.TURN:
			trigger_scope = context.scopes.turn
		ScopeLevel.GLOBAL:
			trigger_scope = context.scopes.global
		_:
			push_error("Invalid scope level for TriggerProto")
			return []
	args.append(trigger_scope)

	return args

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
	
	var scope_level_ = data.get("scope", "GLOBAL")
	match scope_level_.to_upper():
		"BLOCK":
			trigger.scope = ScopeLevel.BLOCK
		"TURN":
			trigger.scope = ScopeLevel.TURN
		"GLOBAL":
			trigger.scope = ScopeLevel.GLOBAL
		_:
			push_error("Error: Invalid scope level for TriggerProto")
			return null

	var target_shorthand = data.get("target", null)
	if (target_shorthand != null):
		trigger.source = ContextExpression.from_string(target_shorthand)
	else:
		trigger.source = ContextExpression.from_string(data.get("source", null))


	return trigger
