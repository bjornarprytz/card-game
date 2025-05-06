class_name CardData
extends Resource

var name: String
var type: String
var _resolve_functions: Array[Callable]
var description: String
var _cost: int
var _target_count: int


func _init(json_object: Dictionary):
	name = json_object["name"]
	_cost = json_object["cost"]
	type = json_object["type"]
	_target_count = 1 # TODO: This needs to be derived from the target accessors
	var effects = json_object["effects"]

	_resolve_functions = []

	for effect in effects:
		var keyword = effect["keyword"]

		var target_index = effect["target_index"] if "target_index" in effect else 0
		
		var parameters = effect["parameters"]
		description += "%s: %s\n" % [keyword, parameters]
		
		var resolve_effect_func = Keywords.create_resolve_func(keyword, target_index, parameters)
		_resolve_functions.append(resolve_effect_func)

func get_cost(_context: PlayContext) -> int:
	return _cost

func get_target_count(_context: PlayContext) -> int:
	return _target_count

func resolve(context: PlayContext):
	for resolve_func in _resolve_functions:
		resolve_func.call(context)
		
