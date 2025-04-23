extends Node2D

@onready var context_factory : PackedScene = preload("res://play_context.tscn")

@onready var interactive_area: Area2D = %InteractiveArea


var id : String = ["Fork", "Knife"].pick_random()

func _ready() -> void:
	CardGameAPI.add_card(CardEngine.Card.new(id))


func _on_interactive_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		var context = context_factory.instantiate() as PlayContext
		context.card_id = id
		get_tree().root.add_child(context)
