class_name GameAction
extends Resource

func pop_next_operation_tree(_game_state: GameState) -> KeywordNode:
	# This method should be overridden by subclasses
	push_error("Error: pop_next_operation_tree() not implemented in GameAction subclass")
	return null

func is_finished() -> bool:
	push_error("Error: is_finished() not implemented in GameAction subclass")
	return true
