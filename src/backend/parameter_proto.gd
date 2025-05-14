class_name ParameterProto
extends Resource

var _immediate: Variant = null
var _accessor: String = ""

func get_value(context: PlayContext) -> Variant:
	if (_immediate != null):
		return _immediate
	
	if (_accessor != ""):
		var value = access_context(context, _accessor)
		if value == null:
			push_error("Error: Accessor %s not found" % _accessor)
			return null
		return value
	
	push_error("Error: No immediate value or accessor found")
	return null


static func from_variant(param: Variant) -> ParameterProto:
	var parameter = ParameterProto.new()

	if param is int:
		parameter._immediate = param
	elif param is bool:
		parameter._immediate = param
	elif param is float:
		parameter._immediate = param
	elif param is String:
		parameter._accessor = param
	
	return parameter

static func access_context(context: PlayContext, accessor: String) -> Variant:
	var path = accessor.split(".")

	if (path.size() != 2):
		push_error("Expected accessor to be of the form 'target.property'")
		return null

	var target_index = path[0].to_int()
	var atom_property_name = path[1]

	var value = context.targets[target_index].atom.get(atom_property_name)

	return value
