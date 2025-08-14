class_name GameSetup
extends EffectBlock

var _context: GameSetupContext

var _is_finished: bool = false

func _init(context_: GameSetupContext) -> void:
	assert(context_ != null, "GameSetupContext cannot be null")
	super (context_)
	_context = context_

func has_next_keyword() -> bool:
	return !_is_finished

func _get_next_keyword() -> KeywordNode:
	var step = Steps.create_operation_tree("setup", _context.state, [_context.initial_state])

	_is_finished = true
	
	return step

func _to_string() -> String:
	return "GameSetup"
