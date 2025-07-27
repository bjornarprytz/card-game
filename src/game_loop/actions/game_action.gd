class_name GameAction
extends EffectBlock

var action_type: String

var _effect_index: int = 0

var _costs_verified: bool = false
var _verified_cost_effects: Array[KeywordNode] = []

func verify_costs() -> bool:
	if (_costs_verified):
		return true
	
	# Verify if the costs can be paid
	var costs = _get_costs()
	for cost in costs:
		var verify_result = cost.verify(context) as PaymentResult
		if not verify_result.is_valid:
			push_error("Cost verification failed for <%s> in action <%s>" % [cost, action_type])
			return false
		_verified_cost_effects.append(verify_result.operation_tree)

	_costs_verified = true
	return true

func has_next_keyword() -> bool:
	# Check if there are more effects to process
	return _effect_index < _get_effects().size()

func next_keyword() -> KeywordNode:
	if (_costs_verified == false):
		push_error("Costs have not been verified for action <%s>" % action_type)
		return KeywordNode.noop("error")
	
	if (_verified_cost_effects.size() > 0):
		# If costs have been verified, return the next cost effect
		return _verified_cost_effects.pop_front()

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

func _get_costs() -> Array[CostProto]:
	# Returns the costs associated with this action
	push_error("GameAction._get_costs() needs to be implemented in a subclass")
	return []

func _get_effects() -> Array[EffectProto]:
	# Returns the effects associated with this action
	push_error("GameAction._get_effects() needs to be implemented in a subclass")
	return []
