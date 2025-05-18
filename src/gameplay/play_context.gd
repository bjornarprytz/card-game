class_name PlayContext
extends Node2D

@onready var message: RichTextLabel = %Message

var card: CardProto

var targets: Array[Targetable] = []

func _ready() -> void:
	if card == null:
		message.text = "Could not find card"
	else:
		message.text = "%s: Choose %d targets" % [card.name, card.targets.size()]
	
	var eligible_targets = get_tree().get_nodes_in_group("Targets")
	for t in eligible_targets:
		if (t is Targetable):
			t.hovered.connect(_on_hover_target)

func _on_hover_target(on: bool, t: Targetable):
	if (on):
		targets = [t]
		t.highlight(true)
	else:
		if (t in targets):
			targets.remove_at(0)
		t.highlight(false)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and !event.is_pressed()):
		queue_free()
		if (card.targets.size() == targets.size() ):
			Keywords.resolve(self)
			print("resolved %s" % card.name)
			

func _exit_tree() -> void:
	get_tree().call_group("Targets", "highlight", false)
