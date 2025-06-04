class_name ParameterProto
extends Resource

var _immediate: Variant = null
var _variableName: String = ""
var _targetIndex: int = -1

func get_value(context: Context) -> Variant:
	if (_immediate != null):
		return _immediate
	
	if (_variableName != ""):
		var value = context.vars[_variableName].resolve(context)
		
		if value == null:
			push_error("Error: Variable %s not found" % _variableName)
			return null
		return value
	
	if (_targetIndex >= 0):
		if context.chosen_targets.size() <= _targetIndex:
			push_error("Error: Target index %d out of bounds" % _targetIndex)
			return null
		return context.chosen_targets[_targetIndex]
	
	push_error("Error: No immediate value or accessor found")
	return null

static func from_target_index(target_index: int) -> ParameterProto:
	assert(target_index >= 0, "Target index must be non-negative")
	
	var parameter = ParameterProto.new()
	parameter._targetIndex = target_index
	return parameter

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
