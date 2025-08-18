class_name ModifierProto
extends EffectProto ## TODO: Is it alright to inherit here?

enum ScopeLevel {
	BLOCK,
	TURN,
	GLOBAL
}

func _init() -> void:
	keyword = "add_modifier"

var modifier_type: Modifier.ModifierType

var property_name: String

var value_modification: ParameterProto

## The lifetime of the modifier
var scope: ScopeLevel

## The atom from which the modifier originates
var source: ContextExpression

## The atom(s) affected by the modifier.
var get_targets: ContextExpression

func _resolve_args(context: Context) -> Array:
	var args = []

	var modifier = Modifier.new(property_name, value_modification.get_value(context), modifier_type)
	args.append(modifier)
	args.append(get_targets)
	var source_atom = source.evaluate(context)
	assert(source_atom is Atom, "Source must be an Atom")
	args.append(source_atom)

	var modifier_scope: Scope
	match scope:
		ScopeLevel.BLOCK:
			modifier_scope = context.scopes.block
		ScopeLevel.TURN:
			modifier_scope = context.scopes.turn
		ScopeLevel.GLOBAL:
			modifier_scope = context.scopes.global
		_:
			push_error("Invalid scope level for ModifierProto")
			return []
	args.append(modifier_scope)

	return args

static func from_dict(data: Dictionary) -> ModifierProto:
	var modifier = ModifierProto.new()

	var property_name_ = data.get("modify", null)
	if (property_name_ == null || property_name_ == ""):
		push_error("Error: ModifierProto property_name is missing")
		return null

	modifier.property_name = property_name_

	var scope_level_ = data.get("scope", "GLOBAL")
	match scope_level_.to_upper():
		"BLOCK":
			modifier.scope = ScopeLevel.BLOCK
		"TURN":
			modifier.scope = ScopeLevel.TURN
		"GLOBAL":
			modifier.scope = ScopeLevel.GLOBAL
		_:
			push_error("Error: Invalid scope level for ModifierProto")
			return null

	modifier.value_modification = ParameterProto.from_variant(data.get("value_modification", null))
	modifier.get_targets = ContextExpression.from_string(data.get("get_targets", null))
	modifier.source = ContextExpression.from_string(data.get("source", null))

	return modifier
