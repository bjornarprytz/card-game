class_name EffectProto
extends Resource

var keyword: String
var _args: Array[ParameterProto] = []
var condition: ContextConditionProto = null

func create_operation_tree(context: Context) -> KeywordNode:
    # Evaluate the condition of the effect
    if not _evaluate_condition(context):
        return KeywordNode.noop(keyword)
    
    # Resolve arguments for the effect
    var args = _resolve_args(context)
    return Keywords.create_operation_tree(keyword, args)

func _resolve_args(context: Context) -> Array[Variant]:
    var args: Array[Variant] = []

    for arg in _args:
        args.append(arg.get_value(context))
    
    return args

func _evaluate_condition(context: Context) -> bool:
    # If no condition is specified, the effect should always run
    if condition == null:
        return true
    
    return condition.evaluate(context)

static func from_dict(data: Dictionary) -> EffectProto:
    if (data.has("modify")):
        return ModifierProto.from_dict(data)

    var effect_data = EffectProto.new()

    effect_data.keyword = data.get("keyword", null)

    var raw_args = data.get("args", [])
    for param in raw_args:
        effect_data._args.append(ParameterProto.from_variant(param))

    # Parse condition if it exists
    if data.has("condition") and data.get("condition") is String:
        var condition_string = data.get("condition")
        if not condition_string.is_empty():
            effect_data.condition = ContextConditionProto.from_string(condition_string)
    
    if not effect_data.keyword:
        push_error("Error: EffectData keyword is missing")
        return null

    if effect_data._args.is_empty():
        push_warning("Warning: EffectData has no args")
    
    return effect_data
