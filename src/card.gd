class_name Card
extends Node2D

@onready var context_factory: PackedScene = preload("res://play_context.tscn")
@onready var interactive_area: Area2D = %InteractiveArea

var card_data: CardProto

func _ready() -> void:
	card_data = CardGameAPI.get_cards().pick_random()

func _on_interactive_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		var context = context_factory.instantiate() as PlayContext
		context.card = card_data
		get_tree().root.add_child(context)
