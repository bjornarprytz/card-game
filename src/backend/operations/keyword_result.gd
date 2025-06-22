class_name KeywordResult
extends Resource

var keyword: String
var args: Array[Variant] = []

var state_changes: Array[StateChange] = []

var sub_results: Array[KeywordResult] = []

func add_sub_result(result: KeywordResult) -> KeywordResult:
	sub_results.append(result)
	return self

func add_state_change(change: StateChange) -> KeywordResult:
	state_changes.append(change)
	return self

func _init(keyword_: String, args_: Array[Variant]) -> void:
	keyword = keyword_
	args = args_

static func noop(keyword_: String, args_: Array[Variant]) -> KeywordResult:
	var result = KeywordResult.new(keyword_, args_)
	return result
