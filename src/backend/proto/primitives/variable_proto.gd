class_name VariableProto
extends Resource

var name: String
var value_expression: ContextExpression = null
var value: Variant = null # For immediate values
var description: String

func resolve(context: Context) -> Variant:
	# If we have an immediate value, return it
	if value != null:
		return value
		
	# If we have an expression, evaluate it
	if value_expression != null:
		return value_expression.evaluate(context)
	
	push_error("Error: Variable '%s' has no value or expression" % name)
	return null

static func from_dict(variable_name: String, data: Dictionary) -> VariableProto:
	var variable_data = VariableProto.new()

	variable_data.name = variable_name
	variable_data.description = data.get("description", "MISSING DESCRIPTION")

	if not variable_data.name:
		push_error("Error: Variable name is missing")
		return null
	
	# Handle different ways of specifying variable values
	if data.has("value"):
		var val = data.get("value")
		if val is String and not (val.begins_with("\"") and val.ends_with("\"")):
			# It's an expression string
			variable_data.value_expression = ContextExpression.from_string(val)
		else:
			# It's an immediate value (number, boolean, or quoted string)
			if val is String and val.begins_with("\"") and val.ends_with("\"") and val.length() >= 2:
				# Remove quotes from string values
				variable_data.value = val.substr(1, val.length() - 2)
			else:
				variable_data.value = val
	else:
		push_error("Error: Variable '%s' has no value defined" % variable_data.name)
		return null

	return variable_data
