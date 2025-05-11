class_name EffectProto
extends Resource

var keyword: String
var target: int
var parameters: Array[int] = []


static func parse_effect_data(data: Dictionary) -> EffectProto:
	var effect_data = EffectProto.new()

	effect_data.keyword = data.get("keyword", null)
	effect_data.target = data.get("target", 0)
	var raw_params = data.get("parameters", [])

	for param in raw_params:
		if param is int:
			effect_data.parameters.append(param)
		if param is float:
			effect_data.parameters.append(int(param))
		else:
			push_error("Invalid parameter type: %s" % param)
			return null
	
	
	if not effect_data.keyword:
		push_error("Error: EffectData keyword is missing")
		return null

	if not effect_data.parameters:
		push_error("Error: EffectData parameters are missing")
		return null
	
	
	return effect_data
