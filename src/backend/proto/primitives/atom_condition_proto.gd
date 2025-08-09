class_name AtomConditionProto
extends Resource

var expressions: Array[AtomExpression] = []

func evaluate(atom: Atom) -> bool:
	if expressions.is_empty():
		return true # No conditions means always true
	for expression in expressions:
		if not expression.evaluate(atom):
			return false
	return true

static func none() -> AtomConditionProto:
	var condition = AtomConditionProto.new()
	return condition

## Create a condition from string expressions like "t0.health > 5", and, "t0.armor = 0"
static func from_expressions(expressions_: Array) -> AtomConditionProto:
	var condition = AtomConditionProto.new()
	for expr in expressions_:
		if not expr is String:
			push_error("Invalid expression type: %s. Expected String." % str(expr))
			continue
		condition.expressions.append(AtomExpression.from_string(expr))
	return condition

func _to_string() -> String:
	if expressions.is_empty():
		return "<No conditions>"
	var expressions_str = []
	for expression in expressions:
		expressions_str.append(expression.to_string())
		
	return "atom => %s" % " AND ".join(expressions_str)
