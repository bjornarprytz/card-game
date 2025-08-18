class_name ScopeProvider
extends Resource


var _turn_count: int = 0
var _block_count: int = 0

## Lasts until the end of the game
var global: Scope:
	get:
		return global

## Lasts one turn
var turn: Scope:
	get:
		return turn

## Lasts one effect block
var block: Scope:
	get:
		return block

func _init() -> void:
	global = Scope.new("global")
	global.open()

func add_result(result: KeywordResult) -> void:
	if (block != null):
		block.add_result(result)
	if (turn != null):
		turn.add_result(result)
	global.add_result(result)

func new_turn() -> void:
	if (block != null):
		block.close()
		push_warning("New turn before block scope was closed (%s)" % block)
		block = null
	
	if (turn != null):
		turn.close()

	turn = Scope.new("turn#%d" % _turn_count)
	_turn_count += 1

	turn.open()

	print(">>%s" % turn)

func new_block() -> void:
	if (block != null):
		block.close()

	block = Scope.new("block#%d" % _block_count)
	_block_count += 1

	block.open()

	print(">>>>%s" % block)

func refresh_modifiers(game_state: GameState) -> void:
	if (block != null):
		block.refresh_modifiers(game_state)
	
	if (turn != null):
		turn.refresh_modifiers(game_state)

	global.refresh_modifiers(game_state)
