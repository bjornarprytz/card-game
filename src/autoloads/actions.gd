extends Node

signal keyword_resolved(result: KeywordResult)

# Utility: snapshot the relevant state of an atom as a dictionary
func snapshot_atom(atom: Atom) -> Dictionary[String, Variant]:
	if atom == null:
		return {}
	# Customize this to include all relevant properties for your game
	return atom.copy_state()

func play_card(context: PlayCardContext) -> bool:
	var chosen_targets = context.chosen_targets
	var required_targets = context.card.card_data.targets
	var effects = context.card.card_data.effects
	
	if (chosen_targets.size() != required_targets.size()):
		return false
	
	for effect in effects:
		# Only execute the effect if its condition is satisfied
		if effect.evaluate_condition(context):
			var args = effect.resolve_args(context)

			# Take before snapshots for all Atom arguments
			var before_states: Dictionary[Atom, Dictionary] = {}
			for arg in args:
				if arg is Atom and before_states.has(arg) == false:
					before_states[arg] = arg.copy_state()

			# Call the keyword
			Keywords.callv(effect.keyword, args)

			var state_changes: Array[StateChange] = []

			for atom in before_states.keys():
				var changes = atom.get_state_diff(before_states[atom])
				for property_name in changes.keys():
					state_changes.append(StateChange.changed(atom, property_name, changes[property_name]))

			keyword_resolved.emit(KeywordResult.from_changes(effect.keyword, state_changes))
	
	return true
