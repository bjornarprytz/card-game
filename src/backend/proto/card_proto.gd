class_name CardProto
extends Resource

var name: String
var cost: int
var type: String
var variables: Dictionary[String, VariableProto] = {}
var targets: Array[TargetProto] = []
var effects: Array[EffectProto] = []


static func from_dict(data: Dictionary) -> CardProto:
    var card_data = CardProto.new()

    card_data.name = data.get("name", null)
    card_data.cost = data.get("cost", null)
    card_data.type = data.get("type", null)

    if not card_data.name:
        push_error("Error: Card name is missing")
        return null

    if not card_data.cost:
        push_error("Error: Card cost is missing")
        return null

    if not card_data.type:
        push_error("Error: Card type is missing")
        return null

    var vars = data.get("vars", {})

    for variableName in vars.keys():
        var variable = vars[variableName]
        variable["name"] = variableName

        var variable_proto = VariableProto.from_dict(variable)
        if variable_proto:
            card_data.variables[variable_proto.name] = variable_proto

    for effect in data.get("effects", []):
        var effect_proto = EffectProto.parse_effect_data(effect)
        if effect_proto:
            card_data.effects.append(effect_proto)

    for target in data.get("targets", [ {}]):
        var target_proto = TargetProto.from_dict(target)
        if target_proto:
            card_data.targets.append(target_proto)

    return card_data
