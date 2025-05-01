class_name CardData
extends Resource

var name: String
var _resolve_func: Callable
var description: String
var _cost: int
var _target_count: int


func _init(name_: String, resolve_func: Callable, description_: String, cost: int = 1, target_count: int = 1):
	name = name_
	description = description_
	
	_resolve_func = resolve_func
	_cost = cost
	_target_count = target_count

	pass

func get_cost(_context: PlayContext) -> int:
	return _cost

func get_target_count(_context: PlayContext) -> int:
	return _target_count

func resolve(context: PlayContext):
	_resolve_func.call(context)
