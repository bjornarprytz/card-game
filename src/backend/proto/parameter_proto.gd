class_name ParameterProto
extends Resource

var _immediate: Variant = null
var _targetIndex: int = -1
var _expression: ContextExpression = null

func get_value(context: Context) -> Variant:
	# If we have an expression, evaluate it
	if (_expression != null):
		return _expression.evaluate(context)
	
	if (_immediate != null):
		return _immediate
	
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

static func from_expression(expr_string: String) -> ParameterProto:
	var parameter = ParameterProto.new()
	parameter._expression = ContextExpression.from_string(expr_string)
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
		# If the string is quoted, treat it as an immediate string value
		if param.begins_with("\"") and param.ends_with("\"") and param.length() >= 2:
			# Remove the quotes and treat as immediate string
			parameter._immediate = param.substr(1, param.length() - 2)
		else:
			# Otherwise, treat it as an expression
			parameter._expression = ContextExpression.from_string(param)
	
	return parameter
