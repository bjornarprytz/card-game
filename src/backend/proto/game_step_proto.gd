class_name GameStepProto
extends Resource

var step_name: String = ""
var effects: Array[EffectProto] = []

static func create_steps() -> Array[GameStepProto]:
    push_error("Implement GameStepProto.create_steps()")
    return []