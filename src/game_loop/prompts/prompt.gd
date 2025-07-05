class_name Prompt
extends Resource

func validate_action(_action: GameAction) -> bool:
    push_error("validate_action not implemented in base Prompt class")
    return false

## TODO: Could it be a good idea for the prompt to create the effect block? For game actions, it would just pass the action through, but for othe prompts it could spare 