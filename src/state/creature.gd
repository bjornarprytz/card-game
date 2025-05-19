class_name Creature
extends Atom

@onready var stats_ui: RichTextLabel = %StatsUI
@onready var name_ui: RichTextLabel = %Name

@export var creature_name: String

var creature_data: CreatureProto

func _ready() -> void:
	creature_data = CardGameAPI.get_creature(creature_name)
	_overwrite_state(creature_data.state)

var health: int:
	set(value):
		_set_property("health", value)
	get:
		return _get_property("health", 0)

var armor: int:
	set(value):
		_set_property("armor", value)
	get:
		return _get_property("armor", 0)

var attack: int:
	set(value):
		_set_property("attack", value)
	get:
		return _get_property("attack", 0)

func _update_ui():
	stats_ui.text = "H:%d|Ar:%d|At:%d" % [health, armor, attack]
	name_ui.text = creature_name

func _to_string() -> String:
	return "Creature(%s)" % name
