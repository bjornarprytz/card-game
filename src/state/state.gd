class_name State
extends Node

signal changed(property: String, value: Variant)

var _properties: Dictionary[String, Variant] = {}


func get_property(key: String, default_value: Variant=null) -> Variant:
	if (_properties.has(key)):
		return _properties[key]
	
	push_warning("Trying to get non-existent property <%s>. Returning default value: %s" % [key, default_value])
	return default_value

func remove_property(key: String) -> bool:
	if (!_properties.has(key)):
		push_warning("Trying to remove non-existent property <%s>" % key)
		return false
	
	_properties.erase(key)
	changed.emit(key, null)
	return true

func set_property(key: String, value: Variant) -> bool:
	if (value == null):
		push_warning("Trying to set property <%s> to null" % key)
		return false
	
	if _properties.has(key):
		var currentValue = _properties[key] as Variant
		if currentValue == value:
			return false
		if typeof(currentValue) != typeof(value):
			push_error("Trying to change the type of %s. %s->%s" % [key, currentValue, value])
			return false
	
	_properties[key] = value
	changed.emit(key, value)
	return true
