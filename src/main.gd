extends Node2D

@onready var draw_pile_count: RichTextLabel = %CardCount
@onready var battlefield: HBoxContainer = %Battlefield
@onready var hand: HBoxContainer = %Hand

@onready var game_state: GameState = $GameState
@onready var game_loop: GameLoop = $GameLoop

func _ready() -> void:
	game_loop.advance_loop()
	game_loop.advance_loop()
	game_loop.advance_loop()
	game_loop.advance_loop()
	game_loop.advance_loop()
	game_loop.advance_loop() ## TODO: Obviously remove this once the UI updates when the game state changes
	
	for creature in game_state.battlefield.atoms:
		battlefield.add_child(creature)
	
	for card in game_state.hand.atoms:
		card.game_loop = game_loop ## TODO: Remove this. It is only here temporarily in order to inject into the context
		hand.add_child(card)

	draw_pile_count.text = "%d" % game_state.draw_pile.atoms.size()

func _on_keyword_resolved(result: KeywordResult):
	for change in result.get_state_changes():
		var atom = game_state.get_atom(change.atom_id)
		if (change.atom_created):
			print("Atom created: %s" % atom)
		else:
			print("%s.%s: %s->%s" % [atom, change.state_key, change.value_before, change.value_after])


func _on_prompt_requested(prompt: PromptNode) -> void:
	print("Prompt requested: %s" % prompt)
