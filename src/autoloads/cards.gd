extends Node


func load_card_data() -> Array[CardProto]:
	# read cards.json
	var file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	if (file == null):
		print("Could not open cards.json")
		return []

	var data = file.get_as_text()
	file.close()

	var cards = GameApi.ParseCardProtos(data)

	return cards
