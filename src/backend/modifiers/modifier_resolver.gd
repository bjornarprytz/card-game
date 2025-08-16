class_name ModifierResolver
extends Resource

var property_name: String

var _additive_modifiers: Array[Modifier] = []
var _multiplicative_modifiers: Array[Modifier] = []
var _division_modifiers: Array[Modifier] = []
var _replacement_modifiers: Array[Modifier] = []

func add_modifier(modifier: Modifier) -> void:
    assert(modifier.property_name == property_name, "Modifier property name mismatch")

    var modifier_group: Array[Modifier]
    match modifier.type:
        Modifier.ModifierType.ADDITIVE:
            modifier_group = _additive_modifiers
        Modifier.ModifierType.MULTIPLICATIVE:
            modifier_group = _multiplicative_modifiers
        Modifier.ModifierType.DIVISION:
            modifier_group = _division_modifiers
        Modifier.ModifierType.REPLACEMENT:
            modifier_group = _replacement_modifiers
        _:
            push_error("Could not add modifier: %s" % modifier)

    if modifier in modifier_group:
        push_error("Modifier %s is already added" % modifier)
    modifier_group.append(modifier)

func remove_modifier(modifier: Modifier) -> void:
    assert(modifier.property_name == property_name, "Modifier property name mismatch")

    var modifier_group: Array[Modifier]
    match modifier.type:
        Modifier.ModifierType.ADDITIVE:
            modifier_group = _additive_modifiers
        Modifier.ModifierType.MULTIPLICATIVE:
            modifier_group = _multiplicative_modifiers
        Modifier.ModifierType.DIVISION:
            modifier_group = _division_modifiers
        Modifier.ModifierType.REPLACEMENT:
            modifier_group = _replacement_modifiers
        _:
            push_error("Could not remove modifier: %s" % modifier)

    if modifier in modifier_group:
        modifier_group.erase(modifier)
    else:
        push_error("Could not find modifier to remove: %s" % modifier)

func compute_value(base_value: Variant) -> Variant:
    if (_replacement_modifiers.size() > 0):
        return _replacement_modifiers[-1].apply(base_value)

    var current_value = base_value

    for modifier in _additive_modifiers:
        current_value = modifier.apply(current_value)

    for modifier in _multiplicative_modifiers:
        current_value = modifier.apply(current_value)

    for modifier in _division_modifiers:
        current_value = modifier.apply(current_value)

    return current_value