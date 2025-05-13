class_name PlayContext
extends Node2D

@onready var message: RichTextLabel = %Message

var card: CardProto

var targets: Array[Target] = []

func _ready() -> void:
	if card == null:
		message.text = "Could not find card"
	else:
		message.text = "%s: Choose %d targets" % [card.name, card.targets.size()]
	
	var eligible_targets = get_tree().get_nodes_in_group("Targets")
	for t in eligible_targets:
		if (t is Target):
			t.hovered.connect(_on_hover_target.bind(t))
	get_tree().call_group("Targets", "highlight", true)

func _on_hover_target(on: bool, t: Target):
	if (on):
		t.highlight(true)
		if (!targets.has(t)):
			targets.push_back(t)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and !event.is_pressed()):
		queue_free()
		if (targets.size() == card.targets.size()):
			Keywords.resolve(self)
			print("resolved %s" % card.name)
			

func _exit_tree() -> void:
	get_tree().call_group("Targets", "highlight", false)
