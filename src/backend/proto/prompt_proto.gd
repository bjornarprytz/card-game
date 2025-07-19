class_name PromptProto
extends Resource

var type: String
var bindings: Dictionary[String, PromptBindingProto] = {}

func _init(type_: String) -> void:
	assert(type_ != "", "Prompt type cannot be empty")
	type = type_

func add_binding(binding: PromptBindingProto):
	if binding == null:
		push_error("Binding cannot be null")
		return

	if (bindings.has(binding.binding_key)):
		push_error("Binding key '%s' already exists in prompt." % binding.binding_key)
		return

	bindings[binding.binding_key] = binding

static func from_variant(variant: Variant) -> PromptProto:
	if not variant is Dictionary:
		push_error("Variant must be a Dictionary for PromptProto.")
		return null
	
	var prompt = PromptProto.new(variant.get("type", ""))

	var bindings_dict = variant.get("bindings", {})
	for key in bindings_dict.keys():
		prompt.add_binding(PromptBindingProto.from_variant(key, bindings_dict[key]))

	return prompt
