class_name GameStepProto
extends Resource

var step_name: String = ""
var effects: Array[EffectProto] = []
var actions: bool = false

func _init(step_name_: String) -> void:
    # Initialize the step with default values if needed
    step_name = step_name_
    effects = []

func add_effect(effect: EffectProto) -> GameStepProto:
    if effect:
        effects.append(effect)
    return self

func allow_actions() -> GameStepProto:
    actions = true
    return self

static func create_steps() -> Array[GameStepProto]:
    var steps: Array[GameStepProto] = [
        GameStepProto.new("setup").add_effect(
            EffectProto.parse_effect_data({
                "keyword": "setup_game",
                "parameters": ["state"]
            })),
        GameStepProto.new("upkeep").add_effect(
            EffectProto.parse_effect_data({
                "keyword": "draw_cards",
                "parameters": ["state", 4]
            })),
        GameStepProto.new("actions").allow_actions(),
        GameStepProto.new("end").add_effect(
            EffectProto.parse_effect_data({
                "keyword": "discard_hand",
                "parameters": ["state"]
            })),
    ]
    return steps
