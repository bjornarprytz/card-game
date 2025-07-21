class_name PromptBindingProto
extends Resource

## Must be unique within the context (effect block)
var binding_key: String
## Atom, number, etc
var binding_type: String

var is_collection: bool

## Fail if fewer than minimum choices are provided.
var strict_min_count: bool = false

var min_count: int = 0
var max_count: int = 1

var description: String = ""
var atom_condition: AtomConditionProto = null

func _init(binding_key_: String, type_info_: TypeInfo, description_: String, condition_: AtomConditionProto = null) -> void:
	assert(binding_key_ != "", "Binding key cannot be empty")
	assert(type_info_.type != "", "Binding type cannot be empty")
	assert(type_info_.min_count >= 0, "Minimum choices must be at least 0")
	assert(type_info_.max_count >= type_info_.min_count, "Maximum choices must be at least as large as minimum choices")
	if (!type_info_.is_collection):
		assert(type_info_.max_count == 1, "Maximum choices must be 1 for single value bindings")

	binding_key = binding_key_
	binding_type = type_info_.type
	min_count = type_info_.min_count
	max_count = type_info_.max_count
	is_collection = type_info_.is_collection

	atom_condition = condition_
	description = description_

func _check_type(value: Variant) -> bool:
	match binding_type:
		"atom":
			if value is Atom:
				return true
		"card":
			if value is Card:
				return true
		"creature":
			if value is Creature:
				return true
		"int":
			if typeof(value) == TYPE_INT:
				return true

	push_error("Value %s is not of type %s" % [value, binding_type])
	return false

func validate_binding(binding: Array) -> bool:
	if (binding.size() < min_count or binding.size() > max_count):
		push_error("Response size is out of bounds: %d (min: %d, max: %d)" % [binding.size(), min_count, max_count])
		return false
	
	for item in binding:
		if not _check_type(item):
			return false
		if atom_condition != null and not atom_condition.evaluate(item):
			push_warning("Condition \"%s\" failed for binding: %s. Item under evaluation: %s" % [atom_condition, binding_key, item])
			return false
	
	return true


static func from_dict(key: String, dict: Dictionary) -> PromptBindingProto:
	var binding_key_ = key
	var type_info = TypeInfo.new(str(dict["type"]))
	
	var description_ = dict["description"]
	if (description_ == null):
		push_error("Description cannot be null for PromptBindingProto")
	
	var condition_expression = dict.get("atom_condition", null)
	if condition_expression != null:
		var condition = AtomConditionProto.from_string(condition_expression)
		return PromptBindingProto.new(binding_key_, type_info, description_, condition)
	
	return PromptBindingProto.new(binding_key_, type_info, description_)

func _to_string() -> String:
	return "%s:%s (%d-%d)" % [binding_key, binding_type, min_count, max_count]


class TypeInfo:
	var type: String
	var min_count: int
	var max_count: int
	var is_collection: bool

	func _init(type_str: String):
		if (type_str == null || type_str.is_empty()):
			push_error("Invalid prompt binding type syntax: %s" % type_str)

		# atom? => type: atom, min: 0, max: 1
		var optional_regex = RegEx.new()
		optional_regex.compile("^([a-zA-Z_][a-zA-Z0-9_]*)\\?$")
		var match_ = optional_regex.search(type_str)
		if match_:
			type = match_.get_string(1)
			min_count = 0
			max_count = 1
			is_collection = false
			return

		var single_regex = RegEx.new()
		single_regex.compile("^([a-zA-Z_][a-zA-Z0-9_]*)$")
		match_ = single_regex.search(type_str)
		if match_:
			type = match_.get_string(1)
			min_count = 1
			max_count = 1
			is_collection = false
			return

		var range_regex = RegEx.new()
		range_regex.compile("^\\[([a-zA-Z_][a-zA-Z0-9_]*)\\:(\\d+)-(\\d+)\\]$")
		# Actually, need to capture the numbers, so:
		range_regex.compile("^\\[([a-zA-Z_][a-zA-Z0-9_]*)\\:(\\d+)-(\\d+)\\]$")
		match_ = range_regex.search(type_str)
		if match_:
			type = match_.get_string(1)
			min_count = int(match_.get_string(2))
			max_count = int(match_.get_string(3))
			is_collection = true
			return

		var exact_regex = RegEx.new()
		exact_regex.compile("^\\[([a-zA-Z_][a-zA-Z0-9_]*)\\:(\\d+)\\]$")
		match_ = exact_regex.search(type_str)
		if match_:
			type = match_.get_string(1)
			min_count = int(match_.get_string(2))
			max_count = int(match_.get_string(2))
			is_collection = true
			return

		push_error("Invalid prompt binding type syntax: %s" % type_str)
