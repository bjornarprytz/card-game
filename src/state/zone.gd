class_name Zone
extends Atom

@export var game_state: GameState

# Array of atoms (cards, creatures, etc.) contained in this zone
var _atoms: Dictionary[int, Atom] = {}

func _ready() -> void:
	assert(game_state != null, "Zone must have a valid GameState reference")

# Add an atom to the zone
func add_atom(atom: Atom):
	if _atoms.has(atom.id):
		push_error("Atom with id <%d> already exists in this zone" % atom.id)
		return
	
	_atoms[atom.id] = atom

# Remove an atom from the zone
func remove_atom(atom: Atom):
	_atoms.erase(atom.id)

var atoms: Array[Atom]:
	get:
		return get_state("atoms", [] as Array[Atom])
