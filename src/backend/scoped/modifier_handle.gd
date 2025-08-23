class_name ModifierHandle
extends ScopedEffectHandle

## The affected atom(s)
var targets: Array[Atom]

## The expression used to determine the atoms affected by the modifier.
var get_targets: ContextExpression

var modifier: Modifier

func _init(modifier_: Modifier, get_targets_: ContextExpression, scope_: Scope, source_: Atom) -> void:
	super._init(scope_, source_)
	modifier = modifier_
	get_targets = get_targets_

func refresh_targets(game_state: GameState) -> void:
	var context = Context.new(game_state, source)

	var updated_targets = get_targets.evaluate(context)

	if (updated_targets is Atom):
		updated_targets = [updated_targets]
	
	if (updated_targets is not Array):
		push_error("ModifierHandle: get_targets did not return an Array or Atom")
		return

	for target in updated_targets:
		if (target in targets):
			# Still relevant
			targets.erase(target)
			continue
		# New target
		target.add_modifier(modifier)

	for target in targets:
		# Outdated target
		target.remove_modifier(modifier)
	
	targets.clear()
	targets.append_array(updated_targets)
	
func apply():
	for target in targets:
		target.add_modifier(modifier)

func remove():
	for target in targets:
		target.remove_modifier(modifier)
