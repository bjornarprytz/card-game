class_name CardEngine
extends Node2D

var gameData: GameProto
var gameState: GameState

func _ready() -> void:
	gameData = DataLoader.load_game_data()
	gameState = DataLoader.load_game_state()

func get_card(card_name: String) -> CardProto:
	if not gameData.cards.has(card_name):
		push_error("Card '%s' not found in game data" % card_name)
	return gameData.cards[card_name]

func get_creature(creature_name: String) -> CreatureProto:
	if not gameData.creatures.has(creature_name):
		push_error("Creature '%s' not found in game data" % creature_name)
	return gameData.creatures[creature_name]
