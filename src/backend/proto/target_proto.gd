class_name TargetProto
extends Resource

var atom_conditions: Array[AtomConditionProto] = []


func evaluate(atom: Atom) -> bool:
	for condition in atom_conditions:
		if not condition.evaluate(atom):
			return false
	return true

static func from_dict(data: Dictionary) -> TargetProto:
	var target_data = TargetProto.new()

	var atom_condition_expressions = data.get("atom_conditions", [])

	for expr in atom_condition_expressions:
		var condition = AtomConditionProto.from_string(expr)
		if condition:
			target_data.atom_conditions.append(condition)

	return target_data
