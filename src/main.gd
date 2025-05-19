extends Node2D

@onready var draw_pile_count: RichTextLabel = %CardCount
@onready var battlefield: HBoxContainer = %Battlefield
@onready var hand: HBoxContainer = %Hand

var game_state: GameState

func _ready() -> void:
	game_state = DataLoader.load_game_state()
	
	for creature in game_state.battlefield:
		battlefield.add_child(creature)
	
	for card in game_state.hand:
		hand.add_child(card)

	draw_pile_count.text = "%d" % game_state.draw_pile.size()
