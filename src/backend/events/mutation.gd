class_name Mutation
extends Resource

var atom: Atom

func is_noop() -> bool:
	return false

static func created(atom_: Atom) -> Mutation:
	return AtomCreated.new(atom_)

static func static_effect_added(effect_handle: StaticEffectHandle) -> Mutation:
	return StaticEffectAdded.new(effect_handle.host, effect_handle.effect)

static func static_effect_removed(effect_handle: StaticEffectHandle) -> Mutation:
	return StaticEffectRemoved.new(effect_handle.host, effect_handle.effect)

static func changed(atom_: Atom, state_key_: String, value_before_: Variant) -> Mutation:
	return StateChange.new(atom_, state_key_, value_before_, atom_.get_state(state_key_))
