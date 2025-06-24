class_name GameLoop
extends Node

@export var game_state: GameState

func _ready() -> void:
	assert(game_state != null, "The game loop needs a reference to the game state")
