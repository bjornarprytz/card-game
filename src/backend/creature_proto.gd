class_name CreatureProto
extends Resource

var name: String
var state: Dictionary = {}

static func from_dict(data: Dictionary) -> CreatureProto:
	var creature_data = CreatureProto.new()

	creature_data.name = data.get("name", null)
	creature_data.state = data.get("state", {})

	if not creature_data.name:
		push_error("Error: Creature name is missing")
		return null

	if not creature_data.state:
		push_error("Error: Creature state is missing")
		return null

	return creature_data
