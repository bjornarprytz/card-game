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
    
    candidate_atoms = candidate_atoms_
    min_choices = min_choices_
    max_choices = max_choices_

func validate_response(action: PromptResponse) -> bool:
    if (action.payload is not Array[Atom]):
        return false

    var selected_atoms = action.payload

    # Check if the number of selected atoms is within the allowed range
    if selected_atoms.size() < min_choices or selected_atoms.size() > max_choices:
        return false
    
    # Check if all selected atoms are in the candidate atoms
    for atom in selected_atoms:
        if not atom in candidate_atoms:
            return false
    
    return true
