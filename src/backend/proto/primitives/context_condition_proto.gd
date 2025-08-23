class_name ContextConditionProto
extends Resource

var expressions: Array[ContextExpression] = []

func evaluate(context: Context) -> bool:
	for expr in expressions:
		var result = expr.evaluate(context)
		if result == null || !result:
			# If there was an error in evaluation, default to false
			return false

	return true

# Create a condition from string expression like "t0.health > 5 AND t0.armor = 0"
static func from_strings(expressions_: Array) -> ContextConditionProto:
	var condition = ContextConditionProto.new()
	if expressions_.is_empty():
		return condition # Empty condition will always evaluate to true

	for expr_string in expressions_:
		if !(expr_string is String):
			push_error("Error: Invalid context expression %s" % expr_string)
			return null

		var expr = ContextExpression.from_string(expr_string)
		if expr == null:
			push_error("Error: Invalid context expression %s" % expr_string)
			return null
		condition.expressions.append(expr)

	return condition
