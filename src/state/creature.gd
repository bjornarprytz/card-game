class_name Creature
extends Atom

@onready var stats_ui: RichTextLabel = %StatsUI
@onready var name_ui: RichTextLabel = %Name

var creature_data: CreatureProto

func _ready() -> void:
	creature_data = CardGameAPI.get_creature(atom_name)
	_init_properties(creature_data.properties)

var health: int:
	get:
		return get_state("health", 0)

var armor: int:
	get:
		return get_state("armor", 0)

var attack: int:
	get:
		return get_state("attack", 0)

func _update_ui():
	stats_ui.text = "H:%d|Ar:%d|At:%d" % [health, armor, attack]
	name_ui.text = atom_name

func _to_string() -> String:
	return "Creature(%s)" % name
