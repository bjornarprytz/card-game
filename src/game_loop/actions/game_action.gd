class_name GameAction
extends Resource

func resolve(_game_state: GameState) -> ActionResult:
    # This method should be overridden by subclasses
    push_error("Error: resolve() not implemented in GameAction subclass")
    return null
