class_name Targetable
extends Control

signal hovered(on:bool, atom: Atom)
@onready var highlight_border: PanelContainer = %HighlightBorder

@export var atom: Atom

func highlight(on: bool):
	if (on):
		highlight_border.show()
	else:
		highlight_border.hide()

func _on_mouse_entered() -> void:
	hovered.emit(true, self)

func _on_mouse_exited() -> void:
	hovered.emit(false, self)
