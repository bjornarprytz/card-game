class_name PromptNode
extends KeywordNode

var _context: Context = null

var prompt_proto: PromptProto

var bound_values: Dictionary[String, Variant] = {}

func _init(prompt_proto_: PromptProto) -> void:
	keyword = "prompt"
	args = [prompt_proto_]
	prompt_proto = prompt_proto_

static func from_args(args_: Array[Variant]) -> PromptNode:
	if args_.size() != 1:
		push_error("PromptNode requires exactly one argument.")
		
	return PromptNode.new(PromptProto.from_variant(args_[0]))

func _resolve_internal() -> KeywordResult:
	var result = KeywordResult.new(keyword, args)

	if bound_values == null:
		push_error("Prompt response has not been bound.")
		return result

	if (bound_values.size() == 0):
		push_warning("Prompt response payload is empty. This may be unintended.")
		return result

	for binding_key in bound_values.keys():
		if (_context.prompt.has(binding_key)):
			push_error("Binding key %s already exists in context player choices." % binding_key)
			continue

		_context.prompt[binding_key] = bound_values[binding_key] ## TODO: Take into consideration if it's a collection or not
	
	return KeywordResult.noop("prompt", args) ## TODO: Possibly provide the response in the result

func validate_response(response: PromptResponse) -> bool:
	if response == null:
		push_error("Prompt response cannot be null.")
		return false
	for binding_key in prompt_proto.bindings.keys():
		var binding = prompt_proto.bindings[binding_key]
		if not binding.validate_binding(response.payload[binding_key]):
			return false
	return true

func try_bind_response(response: PromptResponse, context: Context) -> bool:
	if (context == null):
		push_error("Context cannot be null.")
		return false
	
	if !bound_values.is_empty():
		push_error("Response has already been bound.")
		return false

	if not validate_response(response):
		return false

	for binding_key in response.payload.keys():
		var response_to_bind = response.payload[binding_key]

		if (response_to_bind == null || response_to_bind is not Array):
			push_error("Response payload for binding %s is not a valid array." % binding_key)
			return false

		if (prompt_proto.bindings[binding_key].is_collection):
			bound_values[binding_key] = response_to_bind
		else:
			if response_to_bind.size() > 1:
				push_error("Single value binding %s received multiple values: %s" % [binding_key, response_to_bind])
				return false
			bound_values[binding_key] = response_to_bind[0] if response_to_bind.size() > 0 else null
	_context = context

	return true

func _to_string() -> String:
	var bindings_str = []
	for key in prompt_proto.bindings.keys():
		var binding = prompt_proto.bindings[key]
		bindings_str.append(binding.to_string())
	return "PromptNode(keyword: %s, args: %s, bindings: [%s])" % [keyword, args, ", ".join(bindings_str)]
