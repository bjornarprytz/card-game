class_name PlayCardAction
extends GameAction

var _context: PlayCardContext

var _action_verified: bool = false
var _verified_cost_effects: Array[KeywordNode] = []
var _current_effect_index: int = 0

var preamble: Array[KeywordNode] = []
var cleanup: Array[KeywordNode] = []

func _init(play_card_context: PlayCardContext) -> void:
	assert(play_card_context != null, "PlayCardContext cannot be null")
	action_type = "play_card"
	_context = play_card_context
	context = play_card_context

func get_prompt() -> PromptNode:
	return PromptNode.new(_context, _context.card.card_data.prompts)

func try_verify_and_prepare() -> bool:
	if _action_verified:
		return true
	# Verify costs before proceeding
	if not _verify_and_bind_costs():
		push_warning("Costs for action <%s> could not be verified." % action_type)
		return false
	
	if not _verify_prompts():
		push_warning("Prompts for action <%s> could not be verified." % action_type)
		return false

	preamble.append_array(_verified_cost_effects)
	preamble.append(
		Keywords.create_operation_tree("move_atom", [_context.card, _context.state.resolution])
	)

	cleanup.append(
		Keywords.create_operation_tree("move_atom", [_context.card, _context.state.discard_pile])
	)

	_action_verified = true
	return true

func has_next_keyword() -> bool:
	if preamble.size() > 0 || cleanup.size() > 0:
		return true

	var effects = _context.card.card_data.effects

	return _current_effect_index < effects.size()

func _get_next_keyword() -> KeywordNode:
	assert(has_next_keyword(), "No next keyword available in action <%s>" % action_type)

	if preamble.size() > 0:
		return preamble.pop_front()

	var effects = _context.card.card_data.effects

	if _current_effect_index < effects.size():
		var effect_proto = effects[_current_effect_index]
		_current_effect_index += 1
		return effect_proto.create_operation_tree(context)

	return cleanup.pop_front()

func _verify_prompts() -> bool:
	for prompt in _context.card.card_data.prompts:
		if not prompt.verify_context(context):
			push_warning("Prompt <%s> has not been answered." % prompt.binding_key)
			return false
	return true

func _verify_and_bind_costs() -> bool:
	# Verify if the costs can be paid
	for cost in _context.card.card_data.cost:
		var verify_result = cost.verify(context) as PaymentResult
		if not verify_result.is_valid:
			push_warning("Cost verification failed for <%s> in action <%s>" % [cost, action_type])
			_verified_cost_effects.clear()
			return false
		_verified_cost_effects.append(verify_result.operation_tree)
	
	return true

func _to_string() -> String:
	return "PlayCardAction: %s" % _context.card.card_data.name
