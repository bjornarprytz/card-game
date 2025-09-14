class_name Card
extends Atom

@onready var context_factory: PackedScene = preload("res://gameplay/play_card_ui.tscn")
@onready var card_name_label: RichTextLabel = %CardName
@onready var rules_text: RichTextLabel = %RulesText

var card_data: CardProto

## TODO: Remove this. It is only here temporarily in order to inject into the context
var game_loop: GameLoop

func _ready() -> void:
	atom_type = "card"
	card_name_label.text = atom_name
	card_data = CardGameAPI.get_card(atom_name)

func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and !event.is_pressed()):
		var context = context_factory.instantiate() as PlayCardUI
		context.card = self
		context.game_loop = game_loop
		context.state = game_loop.game_state
		context.context_updated.connect(_on_context_updated)
		get_tree().root.add_child(context)

func _on_context_updated(new_context: PlayCardContext) -> void:
	var text = ""
	for effect in new_context.card.card_data.effects:
		text += effect.keyword
		var args = effect.get_args()
		if args.size() > 0:
			text += " ("
			var first = true
			for arg in args:
				if not first:
					text += ", "
				text += arg.get_display_value_PLACEHOLDER(new_context)
				first = false
			text += ")"
		text += "\n"
	
	rules_text.text = text
