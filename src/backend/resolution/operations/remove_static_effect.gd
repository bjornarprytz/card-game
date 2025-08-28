class_name RemoveStaticEffect
extends Operation

var effect_handle: StaticEffectHandle

func _init(effect_handle_: StaticEffectHandle) -> void:
    effect_handle = effect_handle_


func execute() -> Array[Mutation]:
    effect_handle.host.remove_static_effect(effect_handle)

    return [Mutation.static_effect_removed(effect_handle)]
