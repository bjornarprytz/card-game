class_name Target
extends Node2D

@onready var interactive_area: Area2D = %InteractiveArea
@onready var stats_label: RichTextLabel = %Stats
@onready var atom: Atom

signal hovered(on: bool)

func _ready() -> void:
	atom = CardGameAPI.add_atom() # This should be done elsewhere, and the target would only need the atom ID to get it.
	atom.state_changed.connect(_on_atom_state_changed)
	atom.health = 5
	atom.armor = 0

func highlight(enable: bool):
	if (enable):
		modulate = Utility.random_color()
	else:
		modulate = Color.WHITE

func _on_interactive_area_mouse_entered() -> void:
	hovered.emit(true)

func _on_interactive_area_mouse_exited() -> void:
	hovered.emit(false)


func _on_atom_state_changed(_propertyName: String, _value: Variant) -> void:
	stats_label.text = "%s|%s" % [atom.health, atom.armor]
