class_name GameStep
extends EffectBlock

var step_name: String

var _context: Context
var _is_finished: bool = false

func _init(step_name_: String, game_state: GameState) -> void:
    assert(game_state != null, "GameState cannot be null")
    _context = Context.new(game_state)
    step_name = step_name_

func has_next_keyword() -> bool:
    return !_is_finished

func next_keyword() -> KeywordNode:
    var keyword_node = Steps.create_operation_tree(step_name, _context.game_state)
    _is_finished = true
    return keyword_node
