class_name GameAction
extends EffectBlock

var action_type: String

var _effect_index: int = 0

func has_next_keyword() -> bool:
    # Check if there are more effects to process
    return _effect_index < _get_effects().size()

func next_keyword() -> KeywordNode:
    var effect_proto = _get_effects()[_effect_index]
    _effect_index += 1
    
    # Evaluate the condition of the effect
    if not effect_proto.evaluate_condition(context):
        return KeywordNode.noop(effect_proto.keyword)
    
    # Resolve arguments for the effect
    var args = effect_proto.resolve_args(context)
    return Keywords.create_operation_tree(effect_proto.keyword, args)

func _to_string() -> String:
    # Returns a string representation of the action
    return "GameAction(%s)" % action_type

func _get_effects() -> Array[EffectProto]:
    # Returns the effects associated with this action
    push_error("GameAction._get_effects() needs to be implemented in a subclass")
    return []
