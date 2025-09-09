class_name KeywordDefinition
extends Resource

var _game_state: GameState
var _keyword_provider: KeywordProvider

var _argument_info: Array[Dictionary]

func _init(game_state: GameState, keyword_provider: KeywordProvider):
	_game_state = game_state
	_keyword_provider = keyword_provider
	var method_list = self.get_method_list()
	for method in method_list:
		if method.name == keyword:
			_argument_info = method.args
			break
	
	if _argument_info == null:
		push_error("Method '%s' not found in %s" % [keyword, self.name])

var keyword: String:
	get:
		return _get_keyword()

var arg_count: int:
	get:
		return _argument_info.size()

func _get_keyword() -> String:
	push_error("_get_keyword not implemented in %s" % self.name)
	return "NOT_IMPLEMENTED"

func create_operation_tree(args: Array) -> KeywordNode:
	if (!_validate_args(args)):
		return null
	

	var tree = self.callv(keyword, args)

	return KeywordNode.create(keyword, args, tree)

func _validate_args(args: Array) -> bool:
	if (args.size() != arg_count):
		push_error("%s requires exactly %d arguments, got %d" % [keyword, arg_count, args.size()])
		return false

	push_warning("TODO: more argument validation here?")
	
	return true
