class_name Mutation
extends Resource

var atom: Atom

static func created(atom_: Atom) -> Mutation:
	return AtomCreated.new(atom_)

static func modifier_added(host: Atom, modifier_: Modifier) -> Mutation:
	return ModifierAdded.new(host, modifier_)

static func trigger_added(host: Atom, trigger_: Trigger) -> Mutation:
	return TriggerAdded.new(host, trigger_)

static func changed(atom_: Atom, state_key_: String, value_before_: Variant) -> Mutation:
	return StateChange.new(atom_, state_key_, value_before_, atom_.get_state(state_key_))
