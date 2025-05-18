class_name Creature
extends Atom

@onready var stats_ui: RichTextLabel = %StatsUI

func _ready() -> void:
	health = 10
	armor = 3

var health: int:
	set(value):
		_state.set_property("health", value)
	get:
		return _state.get_property("health", 0)

var armor: int:
	set(value):
		_state.set_property("armor", value)
	get:
		return _state.get_property("armor", 0)

func _update_ui():
	stats_ui.text = "H:%d|A:%d" % [health, armor]

func _to_string() -> String:
	var short_id = id.split("-")[0].trim_prefix("{")
	return "Creature(%s)" % short_id
