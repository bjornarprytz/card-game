extends Node


func load_game_data() -> GameProto:
	# read cards.json
	var file = FileAccess.open("res://data/game_data.json", FileAccess.READ)
	if (file == null):
		push_error("Could not open game_data.json")
		return null

	var json_string = file.get_as_text()
	file.close()

	# parse json
	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		push_error("Error parsing JSON: ", json.error_string)
		return null
	
	var game_data = GameProto.from_dict(json.data)
	

	return game_data
