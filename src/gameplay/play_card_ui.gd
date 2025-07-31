class_name PlayCardUI
extends Node2D

@export var state: GameState
@export var game_loop: GameLoop
@export var card: Card

@onready var message: RichTextLabel = %Message

var _targets: Array[Targetable] = []
var _hovered: Targetable = null

var required_number_of_targets: int

func _ready() -> void:
    ## TODO: Replace this whole logic with the prompt system
    required_number_of_targets = card.card_data.targets.size()
    _update_ui()
    var eligible_targets = get_tree().get_nodes_in_group("Targets")
    for t in eligible_targets:
        if (t is Targetable):
            var is_valid_target = true
            for req in card.card_data.targets:
                if !req.evaluate(t.atom):
                    is_valid_target = false
                    print("Found invalid target: %s for card %s" % [t.atom, card.name])
                    break
            if (is_valid_target):
                t.hovered.connect(_on_hover_target)

func _on_hover_target(on: bool, t: Targetable):
    if (on):
        _hovered = t
        t.highlight(true)
    else:
        if (_hovered == t):
            _hovered = null
        t.highlight(false)

func _toggle_target(target: Targetable):
    if (target in _targets):
        _targets.erase(target)
    else:
        _targets.append(target)

    _update_ui()
    
    if (required_number_of_targets == _targets.size()):
        _resolve()

func _resolve():
    var target_atoms: Array[Atom] = []
    for t in _targets:
        target_atoms.append(t.atom)
    
    var action = PlayCardAction.new(PlayCardContext.create(state, card, target_atoms))
    
    if (game_loop.try_take_action(action)):
        print("Action taken: %s" % action)
    else:
        print("Action failed: %s" % action)
        return

    queue_free()

func _update_ui():
    if (card == null):
        message.text = "Could not find card"
        return
    
    if (required_number_of_targets == 0):
        message.text = "Click anywhere to play."
    else:
        message.text = "Choose target %d/%d" % [_targets.size() + 1, required_number_of_targets]

func _process(_delta: float) -> void:
    global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
    if (event is InputEventMouseButton and !event.is_pressed()):
        if _hovered != null:
            _toggle_target(_hovered)
        elif (required_number_of_targets == 0):
            _resolve()
        else:
            queue_free()
func _exit_tree() -> void:
    get_tree().call_group("Targets", "highlight", false)
