class_name Atom
extends Node

signal state_changed(propertyName: String, value: Variant)
@onready var _state: State = %State

var id : String

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

func _on_state_changed(property: String, value: Variant) -> void:
	state_changed.emit(property, value)
