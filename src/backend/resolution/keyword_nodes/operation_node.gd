class_name OperationNode
extends KeywordNode

var operations: Array[Operation] = []

func _init(keyword_: String, args_: Array[Variant], operations_: Array[Operation]):
	keyword = keyword_
	args = args_
	operations = operations_

	if operations_.is_empty():
		push_error("OperationNode must have at least one operation")
	else:
		operations = operations_.duplicate()

func _resolve_internal() -> KeywordResult:
	var result = KeywordResult.new(keyword, args)
	
	for operation in operations:
		for state_change in operation.execute():
			result.add_state_change(state_change)

	return result
