class_name GameAction
extends Resource

func pop_next_operation_tree(_game_state: GameState) -> Array[Operation]:
    # This method should be overridden by subclasses
    push_error("Error: pop_next_operation_tree() not implemented in GameAction subclass")
    return []
