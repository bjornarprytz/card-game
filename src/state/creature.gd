class_name Creature
extends Atom

@onready var stats_ui: RichTextLabel = %StatsUI

@export var creature_name: String

var creature_data: CreatureProto

func _ready() -> void:
	creature_data = CardGameAPI.get_creature(creature_name)
	self.overwrite_state(creature_data.state)

var health: int:
	set(value):
		state.set_property("health", value)
	get:
		return state.get_property("health", 0)

var armor: int:
	set(value):
		state.set_property("armor", value)
	get:
		return state.get_property("armor", 0)

var attack: int:
	set(value):
		state.set_property("attack", value)
	get:
		return state.get_property("attack", 0)

func _update_ui():
	stats_ui.text = "H:%d|Ar:%d|At:%d" % [health, armor, attack]

func _to_string() -> String:
	return "Creature(%s)" % name
