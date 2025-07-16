class_name Prompt
extends Resource

func validate_action(_action: GameAction) -> bool:
    push_error("validate_action not implemented in base Prompt class")
    return false
