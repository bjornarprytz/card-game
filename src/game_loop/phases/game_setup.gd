class_name GameSetup
extends EffectBlock

var _context: GameSetupContext

var _is_finished: bool = false

func _init(context_: GameSetupContext) -> void:
    assert(context_ != null, "GameSetupContext cannot be null")
    _context = context_

func has_next_keyword() -> bool:
    return !_is_finished

func next_keyword() -> KeywordNode:
    var step = Steps.create_operation_tree("setup", _context.game_state, [_context.initial_state])

    _is_finished = true
    
    return step