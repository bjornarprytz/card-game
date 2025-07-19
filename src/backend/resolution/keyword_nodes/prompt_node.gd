class_name PromptNode
extends KeywordNode

var _response: PromptResponse = null
var _context: Context = null

var _prompt_proto: PromptProto

func _init(prompt_proto: PromptProto) -> void:
	keyword = "prompt"
	args = [prompt_proto]
	_prompt_proto = prompt_proto

static func from_args(args_: Array[Variant]) -> PromptNode:
	if args_.size() != 1:
		push_error("PromptNode requires exactly one argument.")

	var prompt_proto = PromptProto.from_variant(args_[0])
		
	return PromptNode.new(prompt_proto)

func _resolve_internal() -> KeywordResult:
	var result = KeywordResult.new(keyword, args)

	if _response == null:
		push_error("Prompt response has not been bound.")
		return result
	
	if not validate_response(_response):
		push_error("Prompt response validation failed.")

	if (_response.payload.size() == 0):
		push_warning("Prompt response payload is empty. This may be unintended.")
		return result
	
	for binding_key in _response.payload.keys():
		if (_context.prompt.has(binding_key)):
			push_error("Binding key %s already exists in context player choices." % binding_key)
			continue

		_context.prompt[binding_key] = _response.payload[binding_key]
	
	return KeywordResult.noop("prompt", args) ## TODO: Possibly provide the response in the result

func validate_response(response: PromptResponse) -> bool:
	if response == null:
		push_error("Prompt response cannot be null.")
		return false
	for binding_key in _prompt_proto.bindings.keys():
		var binding = _prompt_proto.bindings[binding_key]
		if not binding.validate_response(response.payload.get(binding_key, [])):
			push_error("Response validation failed for binding: %s" % binding_key)
			return false
	return true

func try_bind_response(response: PromptResponse, context: Context) -> bool:
	if (context == null):
		push_error("Context cannot be null.")
		return false
	
	if _response != null:
		push_error("Response has already been bound.")
		return false

	if not validate_response(_response):
		return false

	_response = response
	_context = context

	return true

func _to_string() -> String:
	var bindings_str = []
	for key in _prompt_proto.bindings.keys():
		var binding = _prompt_proto.bindings[key]
		bindings_str.append("%s: %s (min: %d, max: %d)" % [binding.binding_key, binding.binding_type, binding.min_count, binding.max_count])
	return "PromptNode(keyword: %s, args: %s, bindings: [%s])" % [keyword, args, ", ".join(bindings_str)]