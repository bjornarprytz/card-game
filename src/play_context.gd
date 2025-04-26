class_name PlayContext
extends Node2D

var card_id : String
@onready var message: RichTextLabel = %Message

var card : CardEngine.Card

var targets: Array[Node] = []

var chosen_targets: Array[Target] = []
var chosen_target: Target

func _ready() -> void:
	card = CardGameAPI.get_card(card_id)
	if card == null:
		message.text = "Could not find card with id %s" % card_id
	else:
		message.text = "%s: Choose %d targets" % [card.id, card.nTargets]
		
	targets = get_tree().get_nodes_in_group("Targets")
	
	for t in targets:
		if (t is Target):
			t.hovered.connect(_on_hover_target.bind(t))
	
	get_tree().call_group("Targets", "highlight", true)

func _on_hover_target(on: bool, t: Target):
	if (on):
		chosen_target = t
		t.highlight(true)
		if (!chosen_targets.has(t)):
			chosen_targets.push_back(t)
	elif (t == chosen_target):
		chosen_target = null

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and !event.is_pressed()):
		queue_free()
		if (chosen_targets.size() == card.nTargets):
			CardGameAPI.play(card, chosen_targets)

func _exit_tree() -> void:
	get_tree().call_group("Targets", "highlight", false)
	
