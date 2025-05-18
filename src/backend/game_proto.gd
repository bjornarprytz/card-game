class_name GameProto
extends Resource

var cards : Array[CardProto] = []


static func from_dict(dict: Dictionary) -> GameProto:
	var game_proto = GameProto.new()
	var card_data = dict["cards"]

	for card in card_data:
		game_proto.cards.append(CardProto.from_dict(card))
		
	return game_proto
