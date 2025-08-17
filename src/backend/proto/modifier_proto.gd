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
var scope: ScopeLevel
var value_modification: ParameterProto
var targets: ContextExpression

func _resolve_args(context: Context) -> Array:
    var args = []

    return args

static func from_dict(data: Dictionary) -> ModifierProto:
    var modifier = ModifierProto.new()

    var property_name_ = data.get("modify", null)
    if (property_name_ == null):
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
    modifier.targets = ContextExpression.from_string(data.get("targets", null))

    return modifier