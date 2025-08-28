class_name Mutation
extends Resource

var atom: Atom

static func created(atom_: Atom) -> Mutation:
	return AtomCreated.new(atom_)

static func static_effect_added(host: Atom, effect_: StaticEffect) -> Mutation:
	return StaticEffectAdded.new(host, effect_)

static func static_effect_removed(effect_handle_: StaticEffectHandle) -> Mutation:
	return StaticEffectRemoved.new(effect_handle_.host, effect_handle_.eff)

static func changed(atom_: Atom, state_key_: String, value_before_: Variant) -> Mutation:
	return StateChange.new(atom_, state_key_, value_before_, atom_.get_state(state_key_))
