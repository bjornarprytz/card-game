class_name ModifierProto
extends EffectProto ## TODO: Is it alright to inherit here?


enum ScopeLevel {
    BLOCK,
    TURN,
    GLOBAL
}

var property_name: String
var value_modification: Variant
var modifier_type: Modifier.ModifierType
var scope: ScopeLevel


static func from_dict(data: Dictionary) -> ModifierProto:
    ## TODO: Implement from_dict for ModifierProto
    var modifier = ModifierProto.new()
    return modifier