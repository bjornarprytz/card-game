class_name StaticEffectRemoved
extends Mutation

var effect: StaticEffect

func _init(host_: Atom, effect_: StaticEffect) -> void:
    atom = host_
    effect = effect_

func _to_string() -> String:
    return "%s¤%s" % [atom, effect]