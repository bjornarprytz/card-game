class_name StaticEffectAdded
extends Mutation

var effect: StaticEffect

func _init(atom_: Atom, effect_: StaticEffect) -> void:
    atom = atom_
    effect = effect_

func _to_string() -> String:
    return "%s~%s" % [atom, effect]
