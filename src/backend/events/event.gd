class_name Event
extends Resource

var inner_context: Context
var result: KeywordResult


func _init(result_: KeywordResult, context_: Context) -> void:
	result = result_
	inner_context = context_
