class_name ModifierHandle
extends StaticEffectHandle

## The affected atom(s)
var targets: Array[Atom]

## The expression used to determine the atoms affected by the modifier.
var get_targets: ContextExpression

var modifier: Modifier

func _init(modifier_: Modifier, get_targets_: ContextExpression, scope_: Scope, host_: Atom) -> void:
	super._init(scope_, host_, modifier_)
	modifier = modifier_
	get_targets = get_targets_

func refresh_targets(game_state: GameState) -> void:
	var context = ModifierContext.new(game_state, host, host)

	var updated_targets = get_targets.evaluate(context)

	# Make sure it's an array
	if (updated_targets is Atom):
		updated_targets = [updated_targets]
	elif (updated_targets is not Array):
		push_error("ModifierHandle: get_targets did not return an Array or Atom")
		return

	for target in updated_targets:
		if (target in targets):
			# Still a target
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
