class_name EffectProto
extends Resource

var keyword: String
var target: int
var parameters: Array[ParameterProto] = []


static func parse_effect_data(data: Dictionary) -> EffectProto:
	var effect_data = EffectProto.new()

	effect_data.keyword = data.get("keyword", null)
	effect_data.target = data.get("target", 0)
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
