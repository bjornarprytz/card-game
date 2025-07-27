class_name CardProto
extends Resource

var name: String
var type: String
var variables: Dictionary[String, VariableProto] = {}
var prompts: Array[PromptBindingProto] = []
var cost: Array[CostProto] = []
var targets: Array[TargetProto] = [] # TODO: Possibly remove this, as it's covered by the prompt system
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
        card_data.cost.append(CostProto.from_variant(cost_expression))

    var extra_costs = data.get("extra_costs", [])

    for extra_cost in extra_costs:
        var cost_proto = CostProto.from_dict(extra_cost)
        if cost_proto:
            card_data.cost.append(cost_proto)

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

    for target in data.get("targets", [ {}]):
        var target_proto = TargetProto.from_dict(target)
        if target_proto:
            card_data.targets.append(target_proto)
    
    return card_data
