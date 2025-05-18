class_name Atom
extends Node

signal state_changed(propertyName: String, value: Variant)
@onready var _state: State = %State

var id : String = OS.get_unique_id():
	get:
		return id

func _on_state_changed(property: String, value: Variant) -> void:
	state_changed.emit(property, value)
