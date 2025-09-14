class_name KeywordDefinition
extends Resource

class Metadata:
	var keyword: String
	var subjects: Array[ArgInfo]
	var inputs: Array[ArgInfo]

	func validate(args: Array) -> bool:
		if (args.size() != subjects.size() + inputs.size()):
			push_error("Metadata validation failed: expected %d args, got %d" % [subjects.size() + inputs.size(), args.size()])
			return false
		
		# TODO: Maybe expand this to check types?

		return true

var _game_state: GameState
var _keyword_provider: KeywordProvider

var _metadata: Metadata
var _reminder_text: String

func _init(game_state: GameState, keyword_provider: KeywordProvider):
	_game_state = game_state
	_keyword_provider = keyword_provider
	var method_list = self.get_method_list()
	for method in method_list:
		if method.name == keyword:
			_metadata = _create_metadata(method.args)
			break

	if _metadata == null:
		push_error("Method '%s' not found in %s" % [keyword, self])
	
	_reminder_text = _create_reminder_text(_metadata)

var keyword: String:
	get:
		return _get_keyword()

var reminder_text: String:
	get:
		return _reminder_text

## The identifier for this keyword. Should be a static string on the KeywordDefinition (KEYWORD)
func _get_keyword() -> String:
	push_error("_get_keyword not implemented in %s" % self)
	return "NOT_IMPLEMENTED"

func _create_reminder_text(__metadata: Metadata) -> String:
	push_warning("_create_reminder_text not implemented in %s" % self)
	return "Placeholder reminder text for '%s'" % self

## Get the subjects (the atoms being acted upon)
func _get_subjects(keyword_args: Array[Dictionary]) -> Array[ArgInfo]:
	var subjects: Array[ArgInfo] = []
	for i in keyword_args.size():
		if ArgInfo.is_object(keyword_args[i]):
			subjects.append(_create_arg_info(keyword_args, i))
	return subjects

## Get the inputs (additional context for the operation)
func _get_inputs(_keyword_args: Array[Dictionary]) -> Array[ArgInfo]:
	var inputs: Array[ArgInfo] = []
	for i in _keyword_args.size():
		if not ArgInfo.is_object(_keyword_args[i]):
			inputs.append(_create_arg_info(_keyword_args, i))
	return inputs

## Utility to create ArgInfo from a keyword argument dictionary
func _create_arg_info(keyword_args: Array[Dictionary], index: int) -> ArgInfo:
	return ArgInfo.from_dict(keyword_args[index], index)

func get_metadata() -> Metadata:
	return _metadata

func _create_metadata(keyword_args: Array[Dictionary]) -> Metadata:
	var meta = Metadata.new()
	meta.keyword = _get_keyword()
	meta.subjects = _get_subjects(keyword_args)
	meta.inputs = _get_inputs(keyword_args)
	return meta

func create_operation_tree(args: Array) -> KeywordNode:
	if (!_validate_args(args)):
		return null

	var tree = self.callv(keyword, args)

	return KeywordNode.create(keyword, args, tree)

func _validate_args(args: Array) -> bool:
	if (!_metadata.validate(args)):
		return false
	
	return true

func _to_string() -> String:
	return "def(%s)" % keyword
