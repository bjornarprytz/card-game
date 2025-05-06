extends Node


func load_card_data() -> Array[CardData]:
	# read cards.json
	var file = FileAccess.open("res://data/cards.json", FileAccess.READ)
	if (file == null):
		print("Could not open cards.json")
		return []

	var data = file.get_as_text()
	file.close()

	var json = JSON.new()
	if (json.parse(data) != OK):
		print("Could not parse cards.json")
		return []
	var card_data = json.get_data()
	var cards: Array[CardData] = []

	for card in card_data["cards"]:
		cards.append(CardData.new(card))

	return cards
