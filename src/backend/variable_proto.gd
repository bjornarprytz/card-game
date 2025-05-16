class_name VariableProto
extends Resource

var name: String
var expression: String
var description: String

func resolve(context: PlayContext) -> Variant:
    var path = expression.split(".")

    if (path.size() != 2):
        push_error("Expected expression to be of the form 'target.property'")
        return null

    var target_index = path[0].to_int()
    var atom_property_name = path[1]

    var value = context.targets[target_index].atom.get(atom_property_name)

    return value

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