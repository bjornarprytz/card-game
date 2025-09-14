class_name EffectProto
extends Resource

var keyword: String
var _args: Array[ParameterProto] = []
var effect_condition: ContextConditionProto = null

func create_operation_tree(context: Context) -> KeywordNode:
	# Evaluate the effect_condition of the effect
	if not _evaluate_condition(context):
		return KeywordNode.noop(keyword)
	
	# Resolve arguments for the effect
	var args = _resolve_args(context)

	return context.keyword_provider.create_operation_tree(keyword, args)

func get_args() -> Array[ParameterProto]:
	return _args.duplicate()

func _resolve_args(context: Context) -> Array[Variant]:
	var args: Array[Variant] = []

	for arg in _args:
		args.append(arg.get_value(context))
	
	return args

func _evaluate_condition(context: Context) -> bool:
	# If no effect_condition is specified, the effect should always run
	if effect_condition == null:
		return true
	
	return effect_condition.evaluate(context)

static func from_dict(data: Dictionary) -> EffectProto:
	if (data.has("modify")):
		return ModifierProto.from_dict(data)
	
	if (data.has("add_trigger")):
		return TriggerProto.from_dict(data)

	var effect_data = EffectProto.new()

	effect_data.keyword = data.get("keyword", null)

	var raw_args = data.get("args", [])
	for param in raw_args:
		effect_data._args.append(ParameterProto.from_variant(param))

	# Parse effect_condition if it exists
	var condition_strings = data.get("conditions", [])
	if not condition_strings.is_empty():
		effect_data.effect_condition = ContextConditionProto.from_strings(condition_strings)

	if not effect_data.keyword:
		push_error("Error: EffectData keyword is missing")
		return null

	if effect_data._args.is_empty():
		push_warning("Warning: EffectData has no args")
	
	return effect_data

func _to_string() -> String:
	var args_strings = []
	for arg in _args:
		args_strings.append(str(arg))
	return "%s?%s(%s)" % [effect_condition, keyword, ", ".join(args_strings)]
