class_name KeywordResult
extends Resource

class Filter:
	var keyword: String

	func check(result: KeywordResult) -> bool:
		return result.keyword == self.keyword

var keyword: String
var args: Array[Variant] = []

var _sequence: Array[Variant] = []

func is_noop():
	return get_mutations().is_empty()

func add_sub_result(result: KeywordResult) -> KeywordResult:
	_sequence.append(result)
	return self

func add_mutation(change: Mutation) -> KeywordResult:
	_sequence.append(change)
	return self

## Returns all mutations (in order) for this result that match the given filters (filters are ANDed)
func get_mutations(filters: Array[Filter]=[], include_noop: bool=false) -> Array[Mutation]:
	var filtered_mutations: Array[Mutation] = []

	var include_my_mutations = self.match_all(filters)

	for step in _sequence:
		if step is Mutation and include_my_mutations:
			if not include_noop and step.is_noop():
				continue
			filtered_mutations.append(step)
		elif step is KeywordResult:
			filtered_mutations.append_array(step.get_mutations(filters, include_noop))

	return filtered_mutations

## Returns all keywords (in order) for this result that match the given filters (filters are ANDed)
func get_keyword_results(filters: Array[Filter]=[]) -> Array[KeywordResult]:
	if (self.match_all(filters)):
		return [self]

	var results: Array[KeywordResult] = []
	for step in _sequence:
		if step is KeywordResult:
			results.append_array(step.get_keyword_results(filters))
	return results

func _init(keyword_: String, args_: Array[Variant]) -> void:
	keyword = keyword_
	args = args_

func match_all(filters: Array[Filter]) -> bool:
	return filters.is_empty() or filters.all(func(filter): return filter.check(self))

static func noop(keyword_: String, args_: Array[Variant]) -> KeywordResult:
	var result = KeywordResult.new(keyword_, args_)
	return result
