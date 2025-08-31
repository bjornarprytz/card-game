class_name CreateStaticEffect
extends Operation

var effect_handle: StaticEffectHandle

func _init(effect_handle_: StaticEffectHandle) -> void:
    effect_handle = effect_handle_

func execute() -> Array[Mutation]:
    var scope = effect_handle.scope

    scope.add_static_effect(effect_handle)

    return [Mutation.static_effect_added(effect_handle)]
