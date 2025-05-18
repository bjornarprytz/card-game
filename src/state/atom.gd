class_name Atom
extends Node

signal state_changed(propertyName: String, value: Variant)
@onready var state: State = %State

var id : int:
	get:
		return self.get_instance_id()

func _ready() -> void:
	_update_ui()

func overwrite_state(new_state: Dictionary):
	state._properties.clear()
	for prop in new_state.keys():
		state.set_property(prop, new_state[prop])

func _on_state_changed(property: String, value: Variant) -> void:
	state_changed.emit(property, value)
	_update_ui()

func _update_ui():
	pass
