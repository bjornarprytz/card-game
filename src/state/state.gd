class_name State
extends Node

signal changed(property: String, value: Variant)

var _properties: Dictionary[String, Variant] = {}

func clear():
	for prop in _properties.keys():
		remove_property(prop)

func get_property(key: String, default_value: Variant=null) -> Variant:
	key = key.to_lower()
	if (_properties.has(key)):
		return _properties[key]
	
	push_warning("Trying to get non-existent property <%s>. Returning default value: %s" % [key, default_value])
	return default_value

func remove_property(key: String) -> bool:
	key = key.to_lower()
	if (!_properties.has(key)):
		push_warning("Trying to remove non-existent property <%s>" % key)
		return false
	
	_properties.erase(key)
	changed.emit(key, null)
	return true

func set_property(key: String, value: Variant) -> bool:
	key = key.to_lower()
	if (value == null):
		push_warning("Trying to set property <%s> to null" % key)
		return false
	
	if (value is float):
		value = int(value)
		push_warning("Changing type of (%s) from float to int" % key)
	
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
