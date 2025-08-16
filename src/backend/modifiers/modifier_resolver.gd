class_name ModifierResolver
extends Resource

var property_name: String

var _additive_modifiers: Array[Modifier] = []
var _multiplicative_modifiers: Array[Modifier] = []
var _division_modifiers: Array[Modifier] = []
var _replacement_modifiers: Array[Modifier] = []

func add_modifier(modifier: Modifier) -> void:
    assert(modifier.property_name == property_name, "Modifier property name mismatch")

    match modifier.type:
        Modifier.ModifierType.ADDITIVE:
            _additive_modifiers.append(modifier)
        Modifier.ModifierType.MULTIPLICATIVE:
            _multiplicative_modifiers.append(modifier)
        Modifier.ModifierType.DIVISION:
            _division_modifiers.append(modifier)
        Modifier.ModifierType.REPLACEMENT:
            _replacement_modifiers.append(modifier)
        _:
            push_error("Could not add modifier: %s" % modifier)

func remove_modifier(modifier: Modifier) -> void:
    assert(modifier.property_name == property_name, "Modifier property name mismatch")

    match modifier.type:
        Modifier.ModifierType.ADDITIVE:
            _additive_modifiers.erase(modifier)
        Modifier.ModifierType.MULTIPLICATIVE:
            _multiplicative_modifiers.erase(modifier)
        Modifier.ModifierType.DIVISION:
            _division_modifiers.erase(modifier)
        Modifier.ModifierType.REPLACEMENT:
            _replacement_modifiers.erase(modifier)
        _:
            push_error("Could not remove modifier: %s" % modifier)

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