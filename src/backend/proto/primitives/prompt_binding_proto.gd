class_name PromptBindingProto
extends Resource

## Must be unique within the context (effect block)
var binding_key: String
## Atom, number, etc
var binding_type: String

var is_collection: bool

var min_count: int = 0
var max_count: int = 1

func _init(binding_key_: String, binding_type_: String, min_count_: int, max_count_: int) -> void:
    assert(binding_key_ != "", "Binding key cannot be empty")
    assert(binding_type_ != "", "Binding type cannot be empty")
    assert(min_count_ >= 0, "Minimum choices must be at least 0")
    assert(max_count_ >= min_count_, "Maximum choices must be at least as large as minimum choices")
    
    binding_key = binding_key_
    binding_type = binding_type_
    min_count = min_count_
    max_count = max_count_

func _check_type(value: Variant) -> bool:
    ## TODO: This might need to be expanded to support more types
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

func validate_binding(binding: Variant) -> bool:
    if (binding.size() < min_count or binding.size() > max_count):
        push_error("Response size is out of bounds: %d (min: %d, max: %d)" % [binding.size(), min_count, max_count])
        return false
    
    for item in binding:
        if not _check_type(item):
            return false
    
    return true


static func from_variant(key: String, variant: Variant) -> PromptBindingProto:
    if not variant is Dictionary:
        push_error("Variant must be a Dictionary for PromptBindingProto.")
        return null
    
    var binding_key_ = key
    var binding_type_ = variant["type"]

    var single_value_option = variant["single_value"]
    if (single_value_option == null):
        var min_count_ = variant.get("min_count", 0)
        var max_count_ = variant.get("max_count", 1)
        return PromptBindingProto.new(binding_key_, binding_type_, min_count_, max_count_)
    elif single_value_option == "optional":
        return PromptBindingProto.new(binding_key_, binding_type_, 0, 1) ## Optional means 0 or 1
    else:
        return PromptBindingProto.new(binding_key_, binding_type_, 1, 1)


func _to_string() -> String:
    return "%s: %s (%d-%d)" % [binding_key, binding_type, min_count, max_count]


static func collection(binding_key_: String, binding_type_: String, min_count_: int, max_count_: int) -> PromptBindingProto:
    var binding = PromptBindingProto.new(binding_key_, binding_type_, min_count_, max_count_)
    binding.is_collection = true
    return binding