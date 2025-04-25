class_name Target
extends Node2D

@onready var interactive_area: Area2D = %InteractiveArea
@onready var health_label: RichTextLabel = %Health

signal hovered(on: bool)

var health: int:
	set(value):
		health = value
		health_label.text = "%s|%s" % [health, armor]

var armor: int:
	set(value):
		armor = value
		health_label.text = "%s|%s" % [health, armor]

func _ready() -> void:
	health = 5

func highlight(enable: bool):
	if (enable):
		modulate = Utility.random_color()
	else:
		modulate = Color.WHITE

func _on_interactive_area_mouse_entered() -> void:
	hovered.emit(true)

func _on_interactive_area_mouse_exited() -> void:
	hovered.emit(false)
