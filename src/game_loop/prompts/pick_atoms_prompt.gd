class_name PickAtomsPrompt
extends Prompt

var candidate_atoms: Array[Atom] = []

var min_choices: int = 1
var max_choices: int = 1

func _init(candidate_atoms_: Array[Atom], min_choices_: int = 1, max_choices_: int = 1):
    assert(candidate_atoms_.size() > 0, "Candidate atoms cannot be empty")
    assert(min_choices_ >= 1, "Minimum choices must be at least 1")
    assert(max_choices_ >= min_choices_, "Maximum choices must be at least as large as minimum choices")
    assert(min_choices_ <= candidate_atoms_.size(), "Minimum choices cannot exceed the number of candidate atoms")
    
    prompt_type = "pick_atoms"
    candidate_atoms = candidate_atoms_
    min_choices = min_choices_
    max_choices = max_choices_
