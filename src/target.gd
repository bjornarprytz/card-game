class_name Target
extends Node2D

@onready var interactive_area: Area2D = %InteractiveArea

signal hovered(on: bool)

func highlight(enable: bool):
	if (enable):
		modulate = Utility.random_color()
	else:
		modulate = Color.WHITE


func _on_interactive_area_mouse_entered() -> void:
	hovered.emit(true)

func _on_interactive_area_mouse_exited() -> void:
	hovered.emit(false)
