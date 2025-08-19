class_name GameProto
extends Resource

var cards: Dictionary[String, CardProto] = {}
var creatures: Dictionary[String, CreatureProto] = {}

var vars: Dictionary[String, VariableProto] = {}

var initial_game_state: InitialGameState = null

static func from_dict(dict: Dictionary) -> GameProto:
	var game_proto = GameProto.new()

	for card_data in dict["cards"]:
		var card = CardProto.from_dict(card_data)
		game_proto.cards[card.name] = card
	
	for creature_data in dict["creatures"]:
		var creature = CreatureProto.from_dict(creature_data)
		game_proto.creatures[creature.name] = creature

	var variable_keyword_dict: Dictionary = dict.get("variable_keywords", {})
	for variable_name in variable_keyword_dict.keys():
		game_proto.vars[variable_name] = VariableProto.from_dict(variable_name, variable_keyword_dict[variable_name])
	
	if dict.has("initial_game_state"):
		var initial_state_data = dict["initial_game_state"]
		game_proto.initial_game_state = InitialGameState.from_dict(initial_state_data)
	
	return game_proto
