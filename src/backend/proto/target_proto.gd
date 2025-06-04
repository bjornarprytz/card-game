class_name TargetProto
extends Resource

# This will express requirements on the target. For now there are no restrictions

var requirements: String


static func from_dict(data: Dictionary) -> TargetProto:
	var target_data = TargetProto.new()

	target_data.requirements = data.get("requirements", "")

	if not target_data.requirements:
		print("Target requirements are missing, but that's ok for now")

	return target_data
