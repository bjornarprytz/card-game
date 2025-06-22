class_name CreatureProto
extends Resource

var name: String
var properties: Dictionary[String, Variant] = {}

static func from_dict(data: Dictionary) -> CreatureProto:
	var creature_data = CreatureProto.new()

	creature_data.name = data.get("name", null)
	var properties_ = data.get("properties", {})

	for key in properties_.keys():
		creature_data.properties[key.to_lower()] = properties_[key]

	if not creature_data.name:
		push_error("Error: Creature name is missing")
		return null

	if not creature_data.properties:
		push_error("Error: Creature properties are missing")
		return null

	return creature_data
