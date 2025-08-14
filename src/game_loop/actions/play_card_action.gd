class_name PlayCardAction
extends GameAction

var _context: PlayCardContext

var _costs_verified: bool = false
var _verified_cost_effects: Array[KeywordNode] = []

var _current_effect_index: int = 0

func _init(play_card_context: PlayCardContext) -> void:
	assert(play_card_context != null, "PlayCardContext cannot be null")
	action_type = "play_card"
	_context = play_card_context
	context = play_card_context

func get_prompt() -> PromptNode:
	return PromptNode.new(_context, _context.card.card_data.prompts)

func is_valid() -> bool:
	# Verify costs before proceeding
	if not _verify_and_bind_costs():
		push_warning("Costs for action <%s> could not be verified." % action_type)
		return false
	
	if not _verify_prompts():
		push_warning("Prompts for action <%s> could not be verified." % action_type)
		return false

	return true

func has_next_keyword() -> bool:
	if _verified_cost_effects.size() > 0:
		return true

	var effects = _context.card.card_data.effects

	return _current_effect_index < effects.size()

func _get_next_keyword() -> KeywordNode:
	if _verified_cost_effects.size() > 0:
		return _verified_cost_effects.pop_front()

	if not has_next_keyword():
		push_error("No more keywords to resolve in action <%s>" % action_type)
		return null

	var effect_proto = _context.card.card_data.effects[_current_effect_index]
	_current_effect_index += 1

	return _create_keyword_node(effect_proto)

func _verify_prompts() -> bool:
	for prompt in _context.card.card_data.prompts:
		if not prompt.verify_context(context):
			push_warning("Prompt <%s> has not been answered." % prompt.binding_key)
			return false
	return true

func _verify_and_bind_costs() -> bool:
	if (_costs_verified):
		return true
	
	# Verify if the costs can be paid
	for cost in _context.card.card_data.cost:
		var verify_result = cost.verify(context) as PaymentResult
		if not verify_result.is_valid:
			push_warning("Cost verification failed for <%s> in action <%s>" % [cost, action_type])
			_verified_cost_effects.clear()
			return false
		_verified_cost_effects.append(verify_result.operation_tree)

	_costs_verified = true
	return true

func _to_string() -> String:
	return "PlayCardAction: %s" % _context.card.card_data.name
