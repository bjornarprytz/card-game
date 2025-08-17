class_name Atom
extends Node

signal state_changed(key: String, value: Variant)

var _modifiers: Dictionary[String, ModifierResolver] = {}
var _properties: Dictionary[String, Variant] = {}
var _state: Dictionary[String, Variant] = {}

var atom_name: String
var atom_type: String
var id: int = 0

var current_zone: Zone:
	get:
		return get_state("current_zone", null)

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

func get_state(key: String, default_value: Variant = null) -> Variant:
	key = _clean_key(key)
	if (_state.has(key)):
		return _state[key]

	return default_value

func remove_state(key: String) -> bool:
	key = _clean_key(key)
	if (!_state.has(key)):
		push_warning("Trying to remove non-existent state_key <%s>" % key)
		return false
	
	_state.erase(key)
	_on_state_changed(key, null)
	return true

func set_state(key: String, value: Variant) -> bool:
	key = _clean_key(key)
	value = _clean_variant(value)

	if _state.has(key) and _are_equal(_state[key], value):
		return false

	_state[key] = value
	_on_state_changed(key, value)
	return true

func add_modifier(modifier: Modifier) -> void:
	if not _modifiers.has(modifier.property_name):
		_modifiers[modifier.property_name] = ModifierResolver.new()
	_modifiers[modifier.property_name].add_modifier(modifier)

	_on_state_changed(modifier.property_name, modifier)

func remove_modifier(modifier: Modifier) -> void:
	if not _modifiers.has(modifier.property_name):
		push_error("Unable to remove modifier: %s" % modifier)
		return
	_modifiers[modifier.property_name].remove_modifier(modifier)

	_on_state_changed(modifier.property_name, null)

func get_property(key: String, default_value: Variant = null) -> Variant:
	var base_value = get_property_base(key, default_value)
	
	if (_modifiers.has(key)):
		return _modifiers[key].compute_value(base_value)
	
	return base_value

func get_property_base(key: String, default_value: Variant = null) -> Variant:
	key = _clean_key(key)

	if (_properties.has(key)):
		return _properties[key]

	return default_value

func get_property_modifier(key: String, default_value: Variant = null) -> Variant:
	key = _clean_key(key)
	
	if (!_modifiers.has(key)):
		return default_value
	
	var base_value = get_property_base(key, default_value)
	var resolved_value = get_property(key, default_value)
	
	
	if (!Utility.is_number(resolved_value)):
		return resolved_value
	
	return resolved_value - base_value

func _init_properties(properties: Dictionary[String, Variant]) -> void:
	if !_properties.is_empty():
		push_error("Properties already initialized. Cannot reinitialize.")
		return
	for prop in properties.keys():
		_set_property(prop, properties[prop])

func _update_ui():
	# Override this method in subclasses to update the UI
	push_warning("Update UI method not implemented in %s" % self.name)

func _on_state_changed(key: String, value: Variant) -> void:
	state_changed.emit(key, value)
	if self.is_node_ready():
		_update_ui()

func _set_property(key: String, value: Variant) -> bool:
	key = _clean_key(key)
	value = _clean_variant(value)

	if _properties.has(key) and _are_equal(_properties[key], value):
		return false

	_properties[key] = value
	return true

func _clean_key(key: String) -> String:
	return key.to_lower().strip_edges()

func _clean_variant(variant: Variant) -> Variant:
	if (variant is float):
		return int(variant)

	if (variant == null):
		push_warning("Received null variant, returning null")
		return null
	
	return variant

func _are_equal(a: Variant = null, b: Variant = null) -> bool:
	if a == b:
		return true
	
	if typeof(a) != typeof(b):
		push_error("Type mismatch: %s vs %s" % [typeof(a), typeof(b)])
		return false
	
	if a is Array and b is Array:
		if a.size() != b.size():
			return false
		for i in range(a.size()):
			if not _are_equal(a[i], b[i]):
				return false
		return true
	
	return false

func _to_string() -> String:
	return "(%s)%s" % [id, atom_name]
