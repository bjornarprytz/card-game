class_name ActionResult
extends Resource

# The result of a game action

var action: GameAction = null
var keyword_results: Array[KeywordResult] = []

func _init(action_: GameAction) -> void:
    action = action_

func append_result(result: KeywordResult) -> void:
    keyword_results.append(result)