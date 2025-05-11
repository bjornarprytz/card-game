extends Node


func load_card_data() -> Array[CardProto]:
	# read cards.json
	var file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	if (file == null):
		push_error("Could not open cards.json")
		return []

	var json_string = file.get_as_text()
	file.close()

	# parse json
	var json = JSON.new()
	var error = json.parse(json_string)

	if error != OK:
		push_error("Error parsing JSON: ", json.error_string)
		return []
	
	var card_data = json.data["cards"]

	var cards : Array[CardProto] = []

	for card in card_data:
		cards.append(CardProto.from_dict(card))

	return cards
