class_name StateChange
extends Resource

var was_noop: bool

var atom_id: int
var atom_created: bool

var state_key: String
var value_before: Variant
var value_after: Variant

static func created(atom: Atom) -> StateChange:
    var change = StateChange.new()
    change.atom_id = atom.id
    change.atom_created = true
    return change

static func changed(atom: Atom, state_key_: String, value_before_: Variant) -> StateChange:
    var change = StateChange.new()
    change.atom_id = atom.id
    change.atom_created = false
    change.state_key = state_key_
    change.value_before = value_before_
    change.value_after = atom.get_state(state_key_)

    change.was_noop = (change.value_before == change.value_after)

    return change