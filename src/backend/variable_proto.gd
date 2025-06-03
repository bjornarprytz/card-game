class_name VariableProto
extends Resource

var name: String
var expression: String
var description: String

func resolve(context: PlayContext) -> Variant:
	var parts = expression.split(".")

	if (parts.is_empty()):
		push_error("Error: Variable expression is empty")
		return null

	var root = parts[0]
	var path = parts.slice(1)
	
	match root:
		"state":
			return _resolve_path(context.state, path)

	if (root.is_valid_int()):
		var target_index = root.to_int()
		return _resolve_path(context.targets[target_index], path)
	
	push_error("Error: Invalid root '%s' in expression: '%s'" % [root, expression])
	return null

func _resolve_path(root: Variant, path: Array[String]) -> Variant:
	var current = root
	for part in path:
		if part in current:
			current = current[part]
		else:
			push_error("Error: Path '%s' not found in root '%s'" % [part, str(current)])
			return null
	
	return current
	

static func from_dict(data: Dictionary) -> VariableProto:
	var variable_data = VariableProto.new()

	variable_data.name = data.get("name", null)
	variable_data.expression = data.get("expression", null)
	variable_data.description = data.get("description", null)

	if not variable_data.name:
		push_error("Error: Variable name is missing")
		return null

	if not variable_data.expression:
		push_error("Error: Variable expression is missing")
		return null
	
	if not variable_data.description:
		push_error("Error: Variable description is missing")
		return null

	return variable_data
