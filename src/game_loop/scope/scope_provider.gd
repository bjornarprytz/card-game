class_name ScopeProvider
extends Resource

var _game_state: GameState

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

func _init(game_state: GameState) -> void:
	_game_state = game_state
	global = Scope.new("global")
	global.open()

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

func process_event(event: Event) -> Array[EffectBlock]:
	var effect_blocks: Array[EffectBlock] = []

	for scope in [block, turn, global] as Array[Scope]:
		if scope != null:
			effect_blocks.append_array(scope.process_event(event))

	return effect_blocks

func refresh() -> void:
	for scope in [block, turn, global] as Array[Scope]:
		if scope != null:
			scope.refresh(_game_state)
