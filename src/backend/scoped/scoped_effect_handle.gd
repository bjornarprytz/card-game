class_name ScopedEffectHandle
extends Resource

## The source atom. This is the atom that the effect is attached to.
var source: Atom

## The scope in which the handle applies.
var scope: Scope

## The number of turns the effect has been alive. Only relevant for global effects.
var turns_alive: int = 0

func _init(scope_: Scope, source_: Atom) -> void:
    scope = scope_
    source = source_

func turn_tick() -> void:
    turns_alive += 1