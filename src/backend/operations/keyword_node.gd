class_name KeywordNode
extends Resource


var keyword: String
var args: Array[Variant] = []

var is_terminal: bool

var sub_nodes: Array[KeywordNode] # Null if terminal
var operations: Array[Operation] = []

static func composite(keyword_: String, args_: Array[Variant], nodes: Array[KeywordNode]) -> KeywordNode:
	var composite_node = KeywordNode.new()
	composite_node.keyword = keyword_
	composite_node.args = args_
	composite_node.is_terminal = false
	
	composite_node.sub_nodes = nodes.duplicate()
	
	return composite_node

static func terminal(keyword_: String, args_: Array[Variant], operations_: Array[Operation]) -> KeywordNode:
	var node = KeywordNode.new()
	node.keyword = keyword_
	node.args = args_
	node.operations = operations_
	node.is_terminal = true

	return node

static func noop(keyword_: String, args_: Array[Variant]) -> KeywordNode:
	var node = KeywordNode.new()
	node.keyword = keyword_
	node.args = args_
	node.is_terminal = true
	return node

func resolve() -> KeywordResult:
	var result = KeywordResult.new(keyword, args)
	if is_terminal:
		for operation in operations:
			for state_change in operation.execute():
				result.add_state_change(state_change)
	else:
		for sub_node in sub_nodes:
			var sub_result = sub_node.resolve()
			result.add_sub_result(sub_result)
	return result
