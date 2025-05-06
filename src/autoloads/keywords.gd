class_name Keywords
extends Node

static var _instance: Keywords

static var instance: Keywords:
	get:
		if _instance == null:
			_instance = Keywords.new()
		return _instance

static func create_resolve_func(keyword: String, target_index: int, parameters: Array[Variant]) -> Callable:
	return func(context: PlayContext):
		var args = [context.chosen_targets[target_index].atom]
		for param in parameters:
			if (param is String):
				var parts = param.split(".")
				
				var parameter_whence_target_index: int
				var property_name: String

				if (parts.size() == 1):
					parameter_whence_target_index = 0
					property_name = parts[0]
				else:
					var target_accessor = parts[0].trim_prefix("<").trim_suffix(">")

					parameter_whence_target_index = int(target_accessor)
					property_name = parts[1]

				if (context.chosen_targets.size() == 0):
					push_error("No targets chosen, expected 1: %s" % param)
				else:
					args.append(context.chosen_targets[parameter_whence_target_index].get_property(property_name))
			else:
				args.append(param)

		return Keywords.instance.callv(keyword, args)

func damage(target: Atom, amount: int):
	target.armor -= amount
	
	if (target.armor < 0):
		target.health += target.armor
		target.armor = 0

func add_armor(target: Atom, amount: int):
	target.armor += amount

func get_method(method_name: String) -> Callable:
	for m in instance.get_method_list():
		if m["name"] == method_name:
			return instance.call.bind(method_name)
	
	push_error("Method (%s) not found" % method_name)
	return func (): 
		pass
