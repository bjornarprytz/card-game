class_name KeywordResult
extends Resource

var keyword: String

var state_changes: Array[StateChange] = []

var sub_results: Array[KeywordResult] = []

func add_result(result: KeywordResult) -> KeywordResult:
    sub_results.append(result)
    return self

func add_state_change(change: StateChange) -> KeywordResult:
    state_changes.append(change)
    return self

func _init(keyword_: String) -> void:
    keyword = keyword_

static func noop(keyword_: String) -> KeywordResult:
    var result = KeywordResult.new(keyword_)
    return result

static func composite(keyword_: String, sub_results_: Array[KeywordResult]) -> KeywordResult:
    var result = KeywordResult.new(keyword_)
    result.sub_results = sub_results_
    return result

static func from_changes(keyword_: String, changes_: Array[StateChange]) -> KeywordResult:
    var result = KeywordResult.new(keyword_)
    result.state_changes = changes_
    return result
