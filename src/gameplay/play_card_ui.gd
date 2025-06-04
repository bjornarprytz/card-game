class_name PlayCardUI
extends Node2D

@export var state: GameState
@export var card: Card

@onready var message: RichTextLabel = %Message

var _targets: Array[Targetable] = []

func _ready() -> void:
	if card == null:
		message.text = "Could not find card"
	else:
		message.text = "%s: Choose %d targets" % [card.card_data.name, card.card_data.targets.size()]
	
	var eligible_targets = get_tree().get_nodes_in_group("Targets")
	for t in eligible_targets:
		if (t is Targetable):
			t.hovered.connect(_on_hover_target)

func _on_hover_target(on: bool, t: Targetable):
	if (on):
		_targets = [t]
		t.highlight(true)
	else:
		if (t in _targets):
			_targets.remove_at(0)
		t.highlight(false)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and !event.is_pressed()):
		queue_free()
		if (card.card_data.targets.size() == _targets.size()):
			var targets: Array[Atom] = []
			for t in _targets:
				targets.append(t.atom)
			Actions.play_card(PlayCardContext.create(state, card, targets))
			print("resolved %s" % card.name)
			

func _exit_tree() -> void:
	get_tree().call_group("Targets", "highlight", false)
