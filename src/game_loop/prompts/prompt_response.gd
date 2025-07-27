class_name PromptResponse
extends Resource

var payload: Dictionary[String, Variant] = {}

func _init(payload_: Dictionary[String, Variant] = {}) -> void:
    payload = payload_