class_name ArgInfo
extends Resource

var name: String
var type: int
var type_name: String

var arg_index: int


# TODO: Expand this

#- name is theproperty's name, as a String;
#- class_name is an empty StringName, unless the property is [constant TYPE_OBJECT] and it inherits from a class;
#- type is the property'stype, as anint(seeVariant.Type);
#- hint is howtheproperty is meanttobeedited(see[ enum PropertyHint]);
#- hint_stringdependsonthehint(see[ enum PropertyHint]);#
#- usage is acombinationof[ enum PropertyUsageFlags].

static func from_dict(dict: Dictionary, index: int) -> ArgInfo:
	var arg_info = ArgInfo.new()
	arg_info.name = dict.get("name", "N/A")
	arg_info.type = dict.get("type", TYPE_NIL)
	arg_info.type_name = dict.get("class_name", "N/A")
	arg_info.arg_index = index
	return arg_info

## Check if this argument is a subject (an atom being acted upon)
static func is_object(dict: Dictionary) -> bool:
	return dict.get("type", TYPE_NIL) == TYPE_OBJECT

func _to_string() -> String:
	return name
