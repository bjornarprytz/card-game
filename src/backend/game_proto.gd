class_name GameProto
extends Resource

var cards: Dictionary[String, CardProto] = {}
var creatures: Dictionary[String, CreatureProto] = {}

static func from_dict(dict: Dictionary) -> GameProto:
	var game_proto = GameProto.new()

	for card_data in dict["cards"]:
		var card = CardProto.from_dict(card_data)
		game_proto.cards[card.name] = card
	
	for creature_data in dict["creatures"]:
		var creature = CreatureProto.from_dict(creature_data)
		game_proto.creatures[creature.name] = creature
	
	return game_proto
