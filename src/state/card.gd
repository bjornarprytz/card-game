class_name Card
extends Atom

@onready var context_factory: PackedScene = preload("res://gameplay/play_card_ui.tscn")
@onready var card_name_label: RichTextLabel = %CardName

var card_data: CardProto

## TODO: Remove this. It is only here temporarily in order to inject into the context
var game_loop: GameLoop

func _ready() -> void:
	atom_type = "card"
	card_name_label.text = atom_name
	card_data = CardGameAPI.get_card(atom_name)

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and !event.is_pressed()):
		var context = context_factory.instantiate() as PlayCardUI
		context.card = self
		context.game_loop = game_loop
		context.state = game_loop.game_state
		get_tree().root.add_child(context)
