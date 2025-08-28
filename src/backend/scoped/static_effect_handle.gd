class_name StaticEffectHandle
extends Resource

## The host atom. This is the atom that the effect is attached to.
var host: Atom

## The scope in which the handle applies.
var scope: Scope

## The number of turns the effect has been alive. Only relevant for global effects.
var turns_alive: int = 0

## The static effect associated with this handle.
var effect: StaticEffect

func _init(scope_: Scope, host_: Atom, effect_: StaticEffect) -> void:
    scope = scope_
    host = host_
    effect = effect_

func turn_tick() -> Array[EffectBlock]:
    turns_alive += 1
    return []