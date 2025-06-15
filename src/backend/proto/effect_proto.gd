class_name EffectProto
extends Resource

var keyword: String
var parameters: Array[ParameterProto] = []
var condition: ConditionProto = null

func resolve_args(context: Context) -> Array[Variant]:
	var args: Array[Variant] = []
	
	for param in parameters:
		args.append(param.get_value(context))
	
	return args

func evaluate_condition(context: Context) -> bool:
	# If no condition is specified, the effect should always run
	if condition == null:
		return true
	
	return condition.evaluate(context)

static func parse_effect_data(data: Dictionary) -> EffectProto:
	var effect_data = EffectProto.new()

	effect_data.keyword = data.get("keyword", null)

	var raw_params = data.get("parameters", [])
	for param in raw_params:
		effect_data.parameters.append(ParameterProto.from_variant(param))
	
	# Parse condition if it exists
	if data.has("condition") and data.get("condition") is String:
		var condition_string = data.get("condition")
		if not condition_string.is_empty():
			effect_data.condition = ConditionProto.from_string(condition_string)
	
	if not effect_data.keyword:
		push_error("Error: EffectData keyword is missing")
		return null

	if effect_data.parameters.is_empty():
		push_warning("Warning: EffectData has no parameters")
	
	return effect_data
