class_name CostProto
extends Resource

var is_optional: bool = false

var keyword: String
var _args: Array[ParameterProto] = []

func verify(context: Context) -> PaymentResult:
	var resolved_args = _resolve_args(context)
	
	var result = Payments.verify(keyword, resolved_args)

	if (result == null):
		push_error("Cost verification failed for keyword '%s' with args %s" % [keyword, resolved_args])
		return PaymentResult.failure()

	if (is_optional):
		result.make_optional()
	
	return result

func _resolve_args(context: Context) -> Array[Variant]:
	var args: Array[Variant] = []

	for arg in _args:
		args.append(arg.get_value(context))
	
	return args

static func from_variant(value_variant: Variant) -> CostProto:
	var cost_data = CostProto.new()
	
	cost_data.keyword = "pay_resources"
	cost_data._args.append_array([
		ParameterProto.get_state(),
		ParameterProto.from_variant(value_variant)
	])
	cost_data.is_optional = false # Default to not optional unless specified otherwise

	return cost_data

static func from_dict(data: Dictionary) -> CostProto:
	var cost_data = CostProto.new()

	cost_data.keyword = data.get("keyword", null)
	if not cost_data.keyword:
		push_error("Error: Cost keyword is missing")
		return null
	
	var raw_args = data.get("args", [])
	for param in raw_args:
		cost_data._args.append(ParameterProto.from_variant(param))
	
	cost_data.is_optional = data.get("optional", false)
	
	return cost_data

func _to_string() -> String:
	var args_str = []
	for arg in _args:
		args_str.append(arg.to_string()) # Context is not needed for string representation
	return "%s(%s)" % [keyword, args_str]
