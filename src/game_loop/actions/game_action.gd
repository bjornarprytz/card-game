class_name GameAction
extends EffectBlock

var _context: PlayCardContext
var _effects: Array[EffectProto]
var _effect_index: int = 0

var action_type: String

func has_next_keyword() -> bool:
    # Check if there are more effects to process
    return _effect_index < _effects.size()

func next_keyword() -> KeywordNode:
    var effect_proto = _effects[_effect_index]
    _effect_index += 1
    
    # Evaluate the condition of the effect
    if not effect_proto.evaluate_condition(_context):
        return KeywordNode.noop(effect_proto.keyword)
    
    # Resolve arguments for the effect
    var args = effect_proto.resolve_args(_context)
    return Keywords.create_operation_tree(effect_proto.keyword, args)

func _to_string() -> String:
    # Returns a string representation of the action
    return "GameAction(%s)" % action_type