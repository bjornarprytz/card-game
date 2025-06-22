class_name KeywordResultBuilder
extends Resource

var keyword: String
var args: Array[Variant] = []

var sub_results: Array[KeywordResult] = []
var created_atoms: Array[Atom] = []
var atom_before_states: Dictionary[Atom, Dictionary] = {}

func _init(keyword_: String, args_: Array[Variant]) -> void:
    keyword = keyword_
    args = args_.duplicate()

    for arg in args:
        if arg is Atom:
            record_atom(arg)

func record_atom(atom: Atom) -> void:
    if (atom == null):
        push_error("Cannot record null atom")
        return
    
    if (atom_before_states.has(atom)):
        push_warning("Atom <%s> already recorded, overwriting previous state" % atom.name)
    
    atom_before_states[atom] = atom.copy_state()

func add_created_atom(atom: Atom) -> void:
    created_atoms.append(atom)
    record_atom(atom)

func add_sub_result(result: KeywordResult) -> void:
    sub_results.append(result)

func build() -> KeywordResult:
    var result = KeywordResult.new(keyword, args)
    for sub_result in sub_results:
        result.add_sub_result(sub_result)
    for atom in created_atoms:
        result.add_state_change(StateChange.created(atom))
    for atom in atom_before_states.keys():
        var changes = atom.get_state_diff(atom_before_states[atom])
        for property_name in changes.keys():
            result.add_state_change(StateChange.changed(atom, property_name, changes[property_name]))
    
    if (sub_results.is_empty() and created_atoms.is_empty() and atom_before_states.is_empty()):
        return KeywordResult.noop(keyword, args)
    
    return result