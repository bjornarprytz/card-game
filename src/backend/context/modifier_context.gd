class_name ModifierContext
extends Context

## The atom that this modifier is applied to.
var host: Atom

func _init(state_: GameState, source_: Atom, host_: Atom) -> void:
    super._init(state_, source_)
    host = host_