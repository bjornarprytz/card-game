class_name ModifierHandle
extends Resource

## The affected atom(s)
var targets: Array[Atom]

## The source atom.
var source: Atom

## The scope in which the modifier applies.
var scope: Scope

var modifier: Modifier

func apply():
    for target in targets:
        target.add_modifier(modifier)

func remove():
    for target in targets:
        target.remove_modifier(modifier)