class_name GameSetupContext
extends Context

var initial_state: InitialGameState

static func create(game_state: GameState, initial_state_: InitialGameState) -> GameSetupContext:
	var context = GameSetupContext.new(game_state, game_state.root)
	context.initial_state = initial_state_
	return context
