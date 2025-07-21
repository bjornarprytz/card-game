class_name AtomConditionProto
extends Resource

var expression: AtomExpression = null

func evaluate(atom: Atom) -> bool:
	if expression == null:
		push_error("No expression set for AtomConditionProto")
		return false
	return expression.evaluate(atom)

# Create a condition from string expression like "t0.health > 5 AND t0.armor = 0"
static func from_string(expression_string: String) -> AtomConditionProto:
	if expression_string == null || expression_string.is_empty():
		push_error("Expression string cannot be empty for AtomConditionProto")
		return null
		
	var condition = AtomConditionProto.new()
	condition.expression = AtomExpression.from_string(expression_string)
	return condition

func _to_string() -> String:
	if expression == null:
		return "AtomConditionProto: No expression"
	return "%s" % expression.expression_string
