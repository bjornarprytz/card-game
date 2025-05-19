class_name Card
extends Atom

@onready var context_factory: PackedScene = preload("res://gameplay/play_context.tscn")
@onready var card_name_label: RichTextLabel = %CardName

@export var card_name: String

var card_data: CardProto

func _ready() -> void:
	card_name_label.text = card_name
	card_data = CardGameAPI.get_card(card_name)
	_overwrite_state(card_data.state)


func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		var context = context_factory.instantiate() as PlayContext
		context.card = card_data
		get_tree().root.add_child(context)
