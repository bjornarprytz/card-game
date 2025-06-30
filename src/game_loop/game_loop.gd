class_name GameLoop
extends Node

signal keyword_resolved(result: KeywordResult)
signal action_taken(result: ActionResult)
signal phase_changed(new_phase: GamePhase)
signal turn_started(turn: GameTurn)

@export var game_state: GameState

var current_turn: GameTurn:
	set(value):
		assert(value != null, "GameLoop requires a valid GameTurn")
		if current_turn != value:
			if current_turn:
				turn_history.append(current_turn)
			current_turn = value
			turn_started.emit(current_turn)
var current_phase: GamePhase:
	set(value):
		if current_phase != value:
			current_phase = value
			phase_changed.emit(current_phase)

var current_action: ActionResult = null
var turn_history: Array[GameTurn] = []

func _ready() -> void:
	assert(game_state != null, "The game loop needs a reference to the game state")

func setup():
	_resolve_phase(GamePhase.new(["setup"]))

func start_turn(turn: GameTurn):
	current_turn = turn
	start_phase(current_turn.get_next_phase())

func start_phase(phase: GamePhase):
	current_phase = phase
	advance_loop()

func advance_loop():
	if _advance_action():
		return
	
	if current_phase == null || current_phase.is_finished():
		if current_turn == null || current_turn.is_finished():
			var next_turn_index = turn_history.size()
			current_turn = GameTurn.new(next_turn_index)
		current_phase = current_turn.get_next_phase()
	
	_resolve_phase(current_phase)

func validate_action(action: GameAction) -> bool:
	# Check if the action is valid in the current phase
	if current_phase and not current_phase.is_valid_action(action, game_state):
		push_warning("Action <%s> is not valid in phase <%s>" % [action.name, current_phase.name])
		return false
	return true

func try_take_action(action: GameAction) -> bool:
	if not validate_action(action):
		return false
	current_action = ActionResult.new(action)
	_advance_action()
	return true

# (Optional) If you want to keep your effect resolution helpers:
func _resolve_phase(phase: GamePhase) -> void:
	assert(phase != null, "GamePhase cannot be null")
	assert(game_state != null, "GameLoop requires a valid GameState")

	var results = phase.resolve_steps(game_state)
	
	for result in results:
		keyword_resolved.emit(result)
	
	if phase.is_finished():
		advance_loop()

func _advance_action() -> bool:
	if current_action and not current_action.action.is_finished():
		var operation_tree = current_action.action.pop_next_operation_tree(game_state)
		var result = _resolve_operation_tree(operation_tree)
		current_action.append_result(result)
		if current_action.action.is_finished():
			action_taken.emit(current_action)
			current_phase.append_action(current_action)
			current_action = null
		return true
	return false
func _resolve_operation_tree(operation_tree: KeywordNode) -> KeywordResult:
	var result = operation_tree.resolve()
	
	keyword_resolved.emit(result)

	return result
