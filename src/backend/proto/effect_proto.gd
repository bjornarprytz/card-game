class_name EffectProto
extends Resource

var keyword: String
var parameters: Array[ParameterProto] = []

func resolve_args(context: Context) -> Array[Variant]:
	var args: Array[Variant] = []
	
	for param in parameters:
		args.append(param.get_value(context))
	
	return args

static func parse_effect_data(data: Dictionary) -> EffectProto:
	var effect_data = EffectProto.new()

	effect_data.keyword = data.get("keyword", null)

	var target_index = data.get("target", 0)
	if target_index is int and target_index >= 0:
		effect_data.parameters.append(ParameterProto.from_target_index(target_index))

	var raw_params = data.get("parameters", [])
	for param in raw_params:
		effect_data.parameters.append(ParameterProto.from_variant(param))
	
	if not effect_data.keyword:
		push_error("Error: EffectData keyword is missing")
		return null

	if not effect_data.parameters:
		push_error("Error: EffectData parameters are missing")
		return null
	
	
	return effect_data
