class_name PromptNode
extends Resource

var _context: Context = null

var prompts: Array[PromptBindingProto] = []
var _prompts_by_key: Dictionary[String, PromptBindingProto] = {}

var _bound_to_context: bool = false

func _init(context: Context, prompts_: Array[PromptBindingProto]) -> void:
	assert(context != null, "Context cannot be null")
	_context = context
	prompts = prompts_
	for prompt in prompts:
		if not prompt.binding_key in _prompts_by_key:
			_prompts_by_key[prompt.binding_key] = prompt
		else:
			push_error("Duplicate binding key found: %s" % prompt.binding_key)

	if (prompts.size() == 0):
		push_error("PromptNode initialized with no prompts. This is likely a bug.")

func validate_response(response: PromptResponse) -> bool:
	if response == null:
		push_error("Prompt response cannot be null.")
		return false
	
	for prompt in prompts:
		var bindings = response.payload.get(prompt.binding_key, [])
		if not prompt.validate_binding(_context, bindings):
			push_error("Response payload for binding key %s is invalid." % prompt.binding_key)
			return false

	return true

func try_bind_response(response: PromptResponse) -> bool:
	if not validate_response(response):
		return false
	
	if _bound_to_context:
		push_error("Prompt response is already bound to context.")
		return false
	
	var bindings: Dictionary[String, Variant] = {}

	for binding_key in response.payload.keys():
		var response_to_bind = response.payload[binding_key]

		if (_prompts_by_key[binding_key].is_collection):
			bindings[binding_key] = response_to_bind
		else:
			if response_to_bind.size() > 1:
				push_error("Single value binding %s received multiple values: %s" % [binding_key, response_to_bind])
				return false
			bindings[binding_key] = response_to_bind[0] if response_to_bind.size() == 1 else null

	for binding_key in bindings.keys():
		if _context.prompt.has(binding_key):
			push_error("Binding key %s already exists in context prompt." % binding_key)
			return false
		_context.prompt[binding_key] = bindings[binding_key]
	_bound_to_context = true
	return true

func _to_string() -> String:
	var prompts_str = []
	for prompt in prompts:
		prompts_str.append(prompt.to_string())
	return "PromptNode(context: %s, prompts: [%s])" % [_context.to_string(), ", ".join(prompts_str)]
