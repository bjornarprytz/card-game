class_name GamePhase
extends Resource

var _steps: Array[String] = []

var step_results: Array[KeywordResult] = []
var action_results: Array[ActionResult] = []

var _resolved_steps: bool = false
var _allow_actions: bool = false

func _init(steps: Array[String], allow_actions: bool = false) -> void:
	_steps = steps
	_allow_actions = allow_actions

func resolve_steps(_game_state: GameState) -> Array[KeywordResult]:
	assert(_game_state != null, "GamePhase requires a valid GameState")
	assert(not _resolved_steps, "Steps have already been resolved for this phase")

	var keyword_results: Array[KeywordResult] = []
	
	for step in _steps:
		var operation_tree = Steps.create_operation_tree(step, _game_state)
		
		if operation_tree:
			var result = operation_tree.resolve()
			keyword_results.append(result)
			step_results.append(result)
	
	_resolved_steps = true

	return keyword_results

func append_action_result(action_result: ActionResult) -> void:
	assert(action_result != null, "ActionResult cannot be null")
	action_results.append(action_result)

func is_valid_action(_action: GameAction, _game_state: GameState) -> bool:
	return _allow_actions

func is_finished() -> bool:
	return _resolved_steps && !_allow_actions
