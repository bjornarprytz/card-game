class_name CreateCreatureDefinition
extends KeywordDefinition

static var KEYWORD: String = &"create_creature"

func _get_keyword() -> String:
    return KEYWORD

func create_creature(creature_name: String, zone: Zone) -> Array[Operation]:
    var operations: Array[Operation] = []
    operations.append(CreateAtom.new(_game_state, creature_name, "creature", zone))
    return operations
