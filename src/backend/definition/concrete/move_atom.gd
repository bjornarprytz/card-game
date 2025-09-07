class_name MoveAtomDefinition
extends KeywordDefinition

static var KEYWORD: String = &"move_atom"

func _get_keyword() -> String:
	return KEYWORD

func move_atom(card: Atom, zone: Zone) -> Array[Operation]:
	var operations: Array[Operation] = []
	operations.append(ChangeZone.new(card, zone))
	return operations
