class_name CreatureProto
extends Resource

var name: String
var properties: Dictionary = {}

static func from_dict(data: Dictionary) -> CreatureProto:
	var creature_data = CreatureProto.new()

	creature_data.name = data.get("name", null)
	creature_data.properties = data.get("properties", {})

	if not creature_data.name:
		push_error("Error: Creature name is missing")
		return null

	if not creature_data.properties:
		push_error("Error: Creature properties are missing")
		return null

	return creature_data
