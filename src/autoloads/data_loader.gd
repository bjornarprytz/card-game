extends Node


func load_game_data() -> GameProto:
	var json = read_json("res://data/game_data.json")
	
	var game_data = GameProto.from_dict(json.data)
	
	return game_data


func read_json(file_name: String) -> Variant:
	var file = FileAccess.open(file_name, FileAccess.READ)
	if (file == null):
		push_error("Could not open %s" % file_name)
		return null

	var json_string = file.get_as_text()
	file.close()

	# parse json
	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		push_error("Error parsing JSON: ", json.error_string)
		return null
	
	return json
