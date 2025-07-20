class_name PromptBindingProto
extends Resource

## Must be unique within the context (effect block)
var binding_key: String
## Atom, number, etc
var binding_type: String

var is_collection: bool

var min_count: int = 0
var max_count: int = 1

func _init(binding_key_: String, binding_type_: String, min_count_: int, max_count_: int, is_collection_: bool) -> void:
	assert(binding_key_ != "", "Binding key cannot be empty")
	assert(binding_type_ != "", "Binding type cannot be empty")
	assert(min_count_ >= 0, "Minimum choices must be at least 0")
	assert(max_count_ >= min_count_, "Maximum choices must be at least as large as minimum choices")
	if (!is_collection_):
		assert(max_count_ == 1, "Maximum choices must be 1 for single value bindings")

	binding_key = binding_key_
	binding_type = binding_type_
	min_count = min_count_
	max_count = max_count_
	is_collection = is_collection_

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
	
	return true

static func parse_binding_type(type_str: String) -> Dictionary:
	# atom? => type: atom, min: 0, max: 1
	var optional_regex = RegEx.new()
	optional_regex.compile("^([a-zA-Z_][a-zA-Z0-9_]*)\\?$")
	var match_ = optional_regex.search(type_str)
	if match_:
		return {
			"type": match_.get_string(1),
			"min": 0,
			"max": 1,
			"is_collection": false
		}

	var single_regex = RegEx.new()
	single_regex.compile("^([a-zA-Z_][a-zA-Z0-9_]*)$")
	match_ = single_regex.search(type_str)
	if match_:
		return {
			"type": match_.get_string(1),
			"min": 1,
			"max": 1,
			"is_collection": false
		}

	var range_regex = RegEx.new()
	range_regex.compile("^\\[([a-zA-Z_][a-zA-Z0-9_]*)\\:(\\d+)-(\\d+)\\]$")
	# Actually, need to capture the numbers, so:
	range_regex.compile("^\\[([a-zA-Z_][a-zA-Z0-9_]*)\\:(\\d+)-(\\d+)\\]$")
	match_ = range_regex.search(type_str)
	if match_:
		return {
			"type": match_.get_string(1),
			"min": int(match_.get_string(2)),
			"max": int(match_.get_string(3)),
			"is_collection": true
		}

	var exact_regex = RegEx.new()
	exact_regex.compile("^\\[([a-zA-Z_][a-zA-Z0-9_]*)\\:(\\d+)\\]$")
	match_ = exact_regex.search(type_str)
	if match_:
		return {
			"type": match_.get_string(1),
			"min": int(match_.get_string(2)),
			"max": int(match_.get_string(2)),
			"is_collection": true
		}

	push_error("Invalid prompt binding type syntax: %s" % type_str)
	return {
		"type": type_str,
		"min": 1,
		"max": 1,
		"is_collection": false
	}

static func from_variant(key: String, variant: Variant) -> PromptBindingProto:
	if not variant is Dictionary:
		push_error("Variant must be a Dictionary for PromptBindingProto.")
		return null

	var binding_key_ = key
	var type_info = parse_binding_type(str(variant["type"]))
	return PromptBindingProto.new(binding_key_, type_info["type"], type_info["min"], type_info["max"], type_info["is_collection"])


func _to_string() -> String:
	return "%s:%s (%d-%d)" % [binding_key, binding_type, min_count, max_count]
