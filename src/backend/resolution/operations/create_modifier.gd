class_name CreateModifier
extends Operation

var scope: Scope
var modifier: Modifier
var get_targets: ContextExpression
var source: Atom

func _init(modifier_: Modifier, get_targets_: ContextExpression, source_: Atom, scope_: Scope) -> void:
	modifier = modifier_
	get_targets = get_targets_
	source = source_
	scope = scope_

func execute() -> Array[StateChange]:
	var handle = ModifierHandle.new()
	handle.modifier = modifier
	handle.get_targets = get_targets
	handle.source = source
	handle.scope = scope

	scope.add_modifier(handle)
	
	return [StateChange.modifier(source)]
