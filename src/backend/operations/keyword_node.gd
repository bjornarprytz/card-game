class_name KeywordNode
extends Resource

var keyword: String
var args: Array[Variant] = []

var is_terminal: bool

var sub_nodes: Array[KeywordNode] # Null if terminal
var operations: Array[Operation] = []

var _is_resolved: bool = false

static func create(keyword_: String, args_: Array[Variant], contents_: Array) -> KeywordNode:
	var node = KeywordNode.new()
	node.keyword = keyword_
	node.args = args_
	
	if contents_.is_empty():
		node.is_terminal = true
	elif contents_ is Array[Operation]:
		node.is_terminal = true
		node.operations = contents_.duplicate()
	elif contents_ is Array[KeywordNode]:
		node.is_terminal = false
		node.sub_nodes = contents_.duplicate()
	else:
		push_error("Invalid contents type for KeywordNode creation")
		return null

	return node

func resolve() -> KeywordResult:
	assert(!_is_resolved, "KeywordNode has already been resolved")

	var result = KeywordResult.new(keyword, args)
	if is_terminal:
		for operation in operations:
			for state_change in operation.execute():
				result.add_state_change(state_change)
	else:
		for sub_node in sub_nodes:
			var sub_result = sub_node.resolve()
			result.add_sub_result(sub_result)

	_is_resolved = true
	return result
