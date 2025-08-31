class_name ModifierProto
extends StaticEffectProto

## The type of modifier to apply.
var modifier_type: Modifier.ModifierType

## The name of the property to modify on the atom(s).
var property_name: String

## The modification to be applied to the property. Usually resolves to a numeric value.
var value_modification: ParameterProto

## The atom(s) affected by the modifier.
var get_targets: ContextExpression

func _create_handle(context: Context) -> StaticEffectHandle:
	var trigger = Modifier.new(property_name, value_modification.get_value(context), modifier_type)
	var resolved_host = _get_host(context)
	var resolved_scope = _get_scope(context)

	return ModifierHandle.new(trigger, get_targets, resolved_scope, resolved_host)

static func from_dict(data: Dictionary) -> ModifierProto:
	var modifier = ModifierProto.new()

	var property_name_ = data.get("modify", null)
	if (property_name_ == null || property_name_ == ""):
		push_error("Error: ModifierProto property_name is missing")
		return null

	modifier.property_name = property_name_
	modifier.value_modification = ParameterProto.from_variant(data.get("value_modification", null))

	modifier.scope = StaticEffectProto.parse_scope_level(data.get("scope", "GLOBAL"))

	var target_shorthand = data.get("target", null)
	if (target_shorthand != null):
		modifier.host = ContextExpression.from_string(target_shorthand)
		modifier.get_targets = ContextExpression.from_string("@host")
	else:
		modifier.host = ContextExpression.from_string(data.get("host", null))
		modifier.get_targets = ContextExpression.from_string(data.get("get_targets", null))

	modifier.turn_duration = data.get("turn_duration", 0)

	return modifier
