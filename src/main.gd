extends Node2D

@onready var draw_pile_count: RichTextLabel = %CardCount
@onready var battlefield: HBoxContainer = %Battlefield
@onready var hand: HBoxContainer = %Hand

@onready var game_state: GameState = $GameState

func _ready() -> void:
	Actions.keyword_resolved.connect(_on_keyword_resolved)
	initialize_game_state()
	
	for creature in game_state.battlefield.atoms:
		battlefield.add_child(creature)
	
	for card in game_state.hand.atoms:
		hand.add_child(card)

	draw_pile_count.text = "%d" % game_state.draw_pile.atoms.size()

func initialize_game_state():
	# Initialize the game state with the loaded data
	var initial_conditions = DataLoader.load_game_state()

	Actions.initialize_game_state(game_state, initial_conditions)

func _on_keyword_resolved(result: KeywordResult):
	for change in result.get_state_changes():
		var atom = game_state.get_atom(change.atom_id)
		if (change.atom_created):
			print("Atom created: %s" % atom)
		else:
			print("%s.%s: %s->%s" % [atom, change.state_key, change.value_before, change.value_after])
