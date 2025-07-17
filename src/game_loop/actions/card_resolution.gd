class_name CardResolution
extends EffectBlock

var _context: PlayCardContext

var _effects: Array[EffectProto]

var _effect_index: int = 0

func _init(play_card_context: PlayCardContext) -> void:
    assert(play_card_context != null, "PlayCardContext cannot be null")
    _context = play_card_context
    _effects = _context.card.card_data.effects

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
    return "Card(%s)" % _context.card.atom_name