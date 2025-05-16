class_name ParameterProto
extends Resource

var _immediate: Variant = null
var _variableName: String = ""

func get_value(context: PlayContext) -> Variant:
	if (_immediate != null):
		return _immediate
	
	if (_variableName != ""):
		var value = context.card.variables[_variableName].resolve(context)
		
		if value == null:
			push_error("Error: Variable %s not found" % _variableName)
			return null
		return value
	
	push_error("Error: No immediate value or accessor found")
	return null


static func from_variant(param: Variant) -> ParameterProto:
	var parameter = ParameterProto.new()

	if param is int:
		parameter._immediate = param
	elif param is bool:
		parameter._immediate = param
	elif param is float:
		parameter._immediate = param
	elif param is String:
		parameter._variableName = param
	
	return parameter
