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

static func from_variant(variant: Variant) -> PromptBindingProto:
    if not variant is Dictionary:
        push_error("Variant must be a Dictionary for PromptBindingProto.")
        return null
    
    var binding_key = variant.get("key", "")
    var binding_type = variant.get("type", "")
    var min_choices = variant.get("min_choices", 0)
    var max_choices = variant.get("max_choices", 1)
    
    return PromptBindingProto.new(binding_key, binding_type, min_choices, max_choices)