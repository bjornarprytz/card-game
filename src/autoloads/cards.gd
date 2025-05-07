extends Node


func load_card_data() -> Array[Variant]:
	# read cards.json
	var file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	if (file == null):
		print("Could not open cards.json")
		return []

	var data = file.get_as_text()
	file.close()

	GameApi.HelloWorld()

	return GameApi.ParseCardProtos(data)
