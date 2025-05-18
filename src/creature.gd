class_name Creature
extends Atom

@onready var stats_ui: RichTextLabel = %StatsUI

func _ready() -> void:
	health = 10
	armor = 3
	update_ui()

var health: int:
	set(value):
		_state.set_property("health", value)
		update_ui()
	get:
		return _state.get_property("health", 0)

var armor: int:
	set(value):
		_state.set_property("armor", value)
		update_ui()
	get:
		return _state.get_property("armor", 0)

func update_ui():
	stats_ui.text = "h:%d|a:%d" % [health, armor]

func _to_string() -> String:
	return "%s|h:%d|a:%d" % [id, health, armor]
