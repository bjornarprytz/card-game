extends Node2D

@onready var context_factory : PackedScene = preload("res://play_context.tscn")

@onready var interactive_area: Area2D = %InteractiveArea


var id : String = ["Fork", "Knife"].pick_random()

func _ready() -> void:
	CardGameAPI.add_card(CardEngine.Card.new(id, 2, bind_resolver)) # This is not the correct place to load cards.

# TODO: Also inject the context here as well
func bind_resolver(targets: Array[Target]) -> Array[Callable]:
	var resolvers : Array[Callable] = [
		# TODO: Derive this from some syntax
		Keywords.add_armor.bind(targets[0].atom, 1),
		Keywords.deal_damage.bind(targets[1].atom, 1)
		]
	return resolvers

func _on_interactive_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		var context = context_factory.instantiate() as PlayContext
		context.card_id = id
		get_tree().root.add_child(context)
