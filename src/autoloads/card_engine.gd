class_name CardEngine
extends Node2D

var gameData: GameProto

func _ready() -> void:
    gameData = DataLoader.load_game_data()

func get_card(card_name: String) -> CardProto:
    if not gameData.cards.has(card_name):
        push_error("Card '%s' not found in game data" % card_name)
    return gameData.cards[card_name]

func get_creature(creature_name: String) -> CreatureProto:
    if not gameData.creatures.has(creature_name):
        push_error("Creature '%s' not found in game data" % creature_name)
        return null
    return gameData.creatures[creature_name]

func get_step(step_name: String) -> GameStepProto:
    if not gameData.steps.has(step_name):
        push_error("Step '%s' not found in game data" % step_name)
        return null
    return gameData.steps[step_name]
