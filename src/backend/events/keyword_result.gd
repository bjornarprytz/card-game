class_name KeywordResult
extends Resource

var keyword: String
var args: Array[Variant] = []

var mutations: Array[Mutation] = []

var sub_results: Array[KeywordResult] = []

func add_sub_result(result: KeywordResult) -> KeywordResult:
	sub_results.append(result)
	return self

func add_mutation(change: Mutation) -> KeywordResult:
	mutations.append(change)
	return self

func get_mutations() -> Array[Mutation]:
	var all_mutations: Array[Mutation] = mutations.duplicate()

	for sub_result in sub_results:
		all_mutations.append_array(sub_result.get_mutations())

	return all_mutations

func _init(keyword_: String, args_: Array[Variant]) -> void:
	keyword = keyword_
	args = args_

static func noop(keyword_: String, args_: Array[Variant]) -> KeywordResult:
	var result = KeywordResult.new(keyword_, args_)
	return result
