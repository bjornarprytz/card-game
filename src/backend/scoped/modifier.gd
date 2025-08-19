class_name Modifier
extends Resource

enum ModifierType {
	ADDITIVE,
	MULTIPLICATIVE,
	DIVISION,
	REPLACEMENT
}

var property_name: String
var modifier_type: ModifierType
var value: Variant

func apply(current_value: Variant) -> Variant:
	match modifier_type:
		ModifierType.ADDITIVE:
			return current_value + value
		ModifierType.MULTIPLICATIVE:
			return current_value * value
		ModifierType.DIVISION:
			if value == 0:
				push_error("Division by zero error")
				return current_value
			return int(current_value / value)
		ModifierType.REPLACEMENT:
			return value

	push_error("Unhandled modifier type: %s" % modifier_type)
	return current_value

func _init(property_name_: String, value_: Variant, modifier_type_: ModifierType = ModifierType.ADDITIVE) -> void:
	if (modifier_type_ != ModifierType.REPLACEMENT and !Utility.is_number(value_)):
		push_error("Non-replacement modifier must have a numeric value")

	if (modifier_type == ModifierType.DIVISION and value_ == 0):
		push_error("Division modifier cannot have a value of zero")

	property_name = property_name_
	modifier_type = modifier_type_
	value = value_

static func lose(property_name_: String) -> Modifier:
	var modifier = Modifier.new(property_name_, null, ModifierType.REPLACEMENT)
	return modifier

static func replace(property_name_: String, value_: Variant) -> Modifier:
	var modifier = Modifier.new(property_name_, value_, ModifierType.REPLACEMENT)
	return modifier

static func add(property_name_: String, value_: int) -> Modifier:
	if value_ < 1:
		push_warning("Additive modifier should have a positive value")
	var modifier = Modifier.new(property_name_, value_, ModifierType.ADDITIVE)
	return modifier

static func subtract(property_name_: String, value_: int) -> Modifier:
	if value_ < 1:
		push_warning("Subtractive modifier should have a positive value")
	var modifier = Modifier.new(property_name_, -value_, ModifierType.ADDITIVE)
	return modifier

static func multiply(property_name_: String, value_: int) -> Modifier:
	if value_ < 1:
		push_warning("Multiplicative modifier should have a positive value")
	var modifier = Modifier.new(property_name_, value_, ModifierType.MULTIPLICATIVE)
	return modifier

static func divide(property_name_: String, value_: int) -> Modifier:
	if value_ < 1:
		push_warning("Division modifier should have a positive value")
	var modifier = Modifier.new(property_name_, value_, ModifierType.DIVISION)
	return modifier


func _to_string() -> String:
	var modifier_type_str = ""
	match modifier_type:
		ModifierType.ADDITIVE: modifier_type_str = "+"
		ModifierType.MULTIPLICATIVE: modifier_type_str = "*"
		ModifierType.DIVISION: modifier_type_str = "/"
		ModifierType.REPLACEMENT: modifier_type_str = "="
		_: modifier_type_str = "???"

	return "(%s) %s %s" % [property_name, modifier_type_str, value]
