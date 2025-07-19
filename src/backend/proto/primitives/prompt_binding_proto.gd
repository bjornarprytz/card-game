class_name PromptBindingProto
extends Resource

## Must be unique within the context (effect block)
var binding_key: String
## Atom, number, etc
var binding_type: String

var min_choices: int = 0
var max_choices: int = 1

func _init(binding_key_: String, binding_type_: String, min_choices_: int = 0, max_choices_: int = 1) -> void:
	assert(binding_key_ != "", "Binding key cannot be empty")
	assert(binding_type_ != "", "Binding type cannot be empty")
	assert(min_choices_ >= 0, "Minimum choices must be at least 0")
	assert(max_choices_ >= min_choices_, "Maximum choices must be at least as large as minimum choices")
	
	binding_key = binding_key_
	binding_type = binding_type_
	min_choices = min_choices_
	max_choices = max_choices_

func _check_type(value: Variant) -> bool:
	if (binding_type == "card"):
		if value is Card:
			return true
		else:
			push_error("Value %s is not a Card" % value)
			return false
	elif binding_type == "int":
		if typeof(value) == TYPE_INT:
			return true
		else:
			push_error("Value %s is not an int" % value)
			return false
	else:
		push_error("Value %s is not of type %s" % [value, binding_type])
		return false

func validate_response(response: Array) -> bool:
	if (response.size() < min_choices or response.size() > max_choices):
		push_error("Response size is out of bounds: %d (min: %d, max: %d)" % [response.size(), min_choices, max_choices])
		return false
	
	for item in response:
		if not _check_type(item):
			return false
	
	return true


static func from_variant(key: String, variant: Variant) -> PromptBindingProto:
	if not variant is Dictionary:
		push_error("Variant must be a Dictionary for PromptBindingProto.")
		return null
	
	var binding_key_ = key
	var binding_type_ = variant.get("type", "")
	var min_choices_ = variant.get("min_choices", 0)
	var max_choices_ = variant.get("max_choices", 1)

	return PromptBindingProto.new(binding_key_, binding_type_, min_choices_, max_choices_)
