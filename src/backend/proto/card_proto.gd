class_name CardProto
extends Resource

var name: String
var type: String
var variables: Dictionary[String, VariableProto] = {}
var prompts: Array[PromptBindingProto] = []
var cost: Array[CostProto] = []
var effects: Array[EffectProto] = []

static func from_dict(data: Dictionary) -> CardProto:
	var card_data = CardProto.new()

	card_data.name = data.get("name", null)
	card_data.type = data.get("type", null)

	if not card_data.name:
		push_error("Error: Card name is missing")
		return null

	if not card_data.type:
		push_error("Error: Card type is missing")
		return null

	var cost_expression = data.get("cost", 0)

	if (cost_expression > 0):
		card_data.cost.append(CostProto.from_number(cost_expression))

	var extra_costs = data.get("extra_costs", [])

	for extra_cost in extra_costs:
		var cost_proto = CostProto.from_dict(extra_cost)
		if cost_proto:
			card_data.cost.append(cost_proto)
	
	var targets_data = data.get("targets", [])
	for target_data in targets_data:
		var target_binding_proto = PromptBindingProto.from_target_shorthand(target_data)
		if target_binding_proto:
			card_data.prompts.append(target_binding_proto)
	
	var prompt_data = data.get("prompts", {})
	for binding_key in prompt_data.keys():
		var binding_proto = PromptBindingProto.from_dict(binding_key, prompt_data[binding_key])
		if binding_proto:
			card_data.prompts.append(binding_proto)

	var vars = data.get("vars", {})
	for variable_name in vars.keys():
		var variable_proto = VariableProto.from_dict(variable_name, vars[variable_name])
		if variable_proto:
			card_data.variables[variable_name] = variable_proto

	for effect in data.get("effects", []):
		var effect_proto = EffectProto.from_dict(effect)
		if effect_proto:
			card_data.effects.append(effect_proto)

	
	return card_data
