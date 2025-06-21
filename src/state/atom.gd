class_name Atom
extends Node

signal state_changed(propertyName: String, value: Variant)

var _state: Dictionary[String, Variant] = {}

var id: int = 0

var current_zone: Zone:
	set(value):
		if (current_zone != value):
			current_zone = value
			_set_property("current_zone", current_zone)

	get:
		return _get_property("current_zone", null)

func copy_state() -> Dictionary[String, Variant]:
	return _state.duplicate() 

func get_state_diff(other_state: Dictionary[String, Variant]) -> Dictionary[String, Variant]:
	var diff: Dictionary[String, Variant] = {}

	var key_union = _state.keys()
	for key in other_state.keys():
		if not key in key_union:
			key_union.append(key)

	for key in key_union:
		if not other_state.has(key):
			diff[key] = null
		elif not _state.has(key) or _state[key] != other_state[key]:
			diff[key] = other_state[key]
		
	return diff

func _ready() -> void:
	assert(id != 0, "Atom ID must be set before using the atom.")
	_update_ui()

func _update_ui():
	# Override this method in subclasses to update the UI
	push_warning("Update UI method not implemented in %s" % self.name)


func _overwrite_state(new_state: Dictionary):
	_state.clear()
	for prop in new_state.keys():
		_set_property(prop, new_state[prop])

func _on_state_changed(property: String, value: Variant) -> void:
	state_changed.emit(property, value)
	_update_ui()

func _get_property(key: String, default_value: Variant = null) -> Variant:
	key = key.to_lower()
	if (_state.has(key)):
		return _state[key]
	
	push_warning("Trying to get non-existent property <%s>. Returning default value: %s" % [key, default_value])
	return default_value

func _remove_property(key: String) -> bool:
	key = key.to_lower()
	if (!_state.has(key)):
		push_warning("Trying to remove non-existent property <%s>" % key)
		return false
	
	_state.erase(key)
	_on_state_changed(key, null)
	return true

func _set_property(key: String, value: Variant) -> bool:
	key = key.to_lower()
	if (value == null):
		push_warning("Trying to set property <%s> to null" % key)
		return false
	
	if (value is float):
		value = int(value)
		push_warning("Changing type of (%s) from float to int" % key)
	
	if _state.has(key):
		var currentValue = _state[key] as Variant
		if currentValue == value:
			return false
		if typeof(currentValue) != typeof(value):
			push_error("Trying to change the type of %s. %s->%s" % [key, currentValue, value])
			return false
	
	_state[key] = value
	_on_state_changed(key, value)
	return true
