class_name CreateModifier
extends Operation

var scope: Scope
var modifier: Modifier
var get_targets: ContextExpression
var host: Atom

func _init(modifier_: Modifier, get_targets_: ContextExpression, host_: Atom, scope_: Scope) -> void:
	modifier = modifier_
	get_targets = get_targets_
	host = host_
	scope = scope_

func execute() -> Array[Mutation]:
	var handle = ModifierHandle.new(modifier, get_targets, scope, host)

	scope.add_modifier(handle)
	
	return [Mutation.modifier_added(host, modifier)]
