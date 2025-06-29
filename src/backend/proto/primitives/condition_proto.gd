class_name ConditionProto
extends Resource

var expression: ContextExpression = null

func evaluate(context: Context) -> bool:
	# If no condition is specified, it's always true
	if expression == null:
		return true
	
	var result = expression.evaluate(context)
	if result == null:
		# If there was an error in evaluation, default to false
		return false
	
	return result

# Create a condition from string expression like "t0.health > 5 AND t0.armor = 0"
static func from_string(expression_string: String) -> ConditionProto:
	if expression_string.is_empty():
		return null
		
	var condition = ConditionProto.new()
	condition.expression = ContextExpression.from_string(expression_string)
	return condition
