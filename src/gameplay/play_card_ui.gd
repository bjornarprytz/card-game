class_name PlayCardUI
extends CanvasItem

@export var state: GameState
@export var game_loop: GameLoop
@export var card: Card

@onready var option_button_factory: PackedScene = preload("res://gameplay/prompt_option.tscn")

@onready var candidate_list: VBoxContainer = %CandidateList
@onready var confirm: Button = %Confirm
@onready var card_name: RichTextLabel = %CardName

@onready var message: RichTextLabel = %Message
@onready var requirements: RichTextLabel = %Requirements
@onready var description: RichTextLabel = %Description

var context: PlayCardContext
var action: PlayCardAction
var prompt_node: PromptNode

var prompts: Array[PromptBindingProto] = []

var current_prompt: PromptBindingProto = null
var candidates: Array[Atom] = []
var current_choices: Array[Atom] = []

var current_bindings: Dictionary[String, Variant] = {}

func _ready() -> void:
	assert(card != null, "Card cannot be null")
	_reset()
	

func _reset():
	context = PlayCardContext.create(state, card)
	action = PlayCardAction.new(context)
	prompt_node = action.get_prompt()
	prompts = prompt_node.prompts.duplicate()

	current_prompt = null
	candidates = []
	current_choices = []
	current_bindings = {}

	_next_prompt()


func _next_prompt() -> void:
	current_choices = []
	if (prompts.size() > 0):
		current_prompt = prompts.pop_front()
		candidates = current_prompt.get_candidates(context)
		_update_ui()
	else:
		current_prompt = null
		push_warning("No more prompts available for card: %s" % card.name)
	
	_update_confirm_button_state()

func _confirm_candidates() -> void:
	if prompt_node.validate_binding(current_prompt.binding_key, current_choices):
		current_bindings[current_prompt.binding_key] = current_choices.duplicate()
		_next_prompt()
	else:
		push_error("Failed to confirm candidates for prompt: %s" % current_prompt)

func _resolve():
	if (!prompt_node.try_bind_response(PromptResponse.new(current_bindings))):
		print("Failed to bind prompt response.")
		_reset()
		return
		
	if (game_loop.try_take_action(action)):
		print("Action taken: %s" % action)
	else:
		print("Action failed: %s" % action)
		_reset()
		return

	queue_free()

func _update_ui():
	Utility.clear_children(candidate_list)
	if (current_prompt == null):
		push_warning("No current prompt to update UI for.")
		return

	for candidate in candidates:
		var button = option_button_factory.instantiate() as Button
		button.text = str(candidate)
		button.toggled.connect(_on_candidate_pressed.bind(candidate))
		candidate_list.add_child(button)

	if current_prompt.max_count == current_prompt.min_count:
		requirements.text = "%d" % [current_prompt.max_count]
	else:
		requirements.text = "%d-%d" % [current_prompt.min_count, current_prompt.max_count]
	
	description.text = current_prompt.description
	card_name.text = card.card_data.name

func _on_candidate_pressed(toggled_on: bool, candidate: Atom) -> void:
	if toggled_on:
		if candidate in current_choices:
			push_warning("Candidate already selected: %s" % candidate)
		else:
			current_choices.append(candidate)
	else:
		if candidate not in current_choices:
			push_warning("Candidate not found in current choices: %s" % candidate)
		else:
			current_choices.erase(candidate)
	_update_confirm_button_state()

func _on_confirm_pressed() -> void:
	if (current_prompt != null):
		_confirm_candidates()
	
	if (current_prompt == null):
		_resolve()

func _update_confirm_button_state() -> void:
	if current_prompt == null:
		confirm.disabled = false
		return

	confirm.disabled = current_choices.size() < current_prompt.min_count || current_choices.size() > current_prompt.max_count
