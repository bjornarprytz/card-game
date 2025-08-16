class_name ModifierHandle
extends Resource

var targets: Array[Atom]
var source: Atom
var scope: Scope

var modifier: Modifier

func apply():
    for target in targets:
        target.add_modifier(modifier)

func remove():
    for target in targets:
        target.remove_modifier(modifier)