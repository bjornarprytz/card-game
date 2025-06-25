extends Node

signal keyword_resolved(result: KeywordResult)

func initialize_game_state(game_state: GameState, initial_conditions: Variant) -> void:
    # TODO: Create type for initial_conditions
    # Initialize player state
    game_state.player.starting_lives = int(initial_conditions["player"]["starting_lives"])
    game_state.player.starting_resources = int(initial_conditions["player"]["starting_resources"])
    game_state.player.starting_hand_size = int(initial_conditions["player"]["starting_hand_size"])

    for card_name in initial_conditions["deck"]:
        _resolve_keyword("create_card", [game_state, card_name, game_state.draw_pile])
    for card_name in initial_conditions["discard_pile"]:
        _resolve_keyword("create_card", [game_state, card_name, game_state.discard_pile])
    for card_name in initial_conditions["hand"]:
        _resolve_keyword("create_card", [game_state, card_name, game_state.hand])
    for creature_name in initial_conditions["battlefield"]:
        _resolve_keyword("create_creature", [game_state, creature_name, game_state.battlefield])

func play_card(context: PlayCardContext) -> bool:
    var chosen_targets = context.chosen_targets
    var required_targets = context.card.card_data.targets
    var effects = context.card.card_data.effects
    
    if (chosen_targets.size() != required_targets.size()):
        return false
    
    for effect in effects:
        # Only execute the effect if its condition is satisfied
        if effect.evaluate_condition(context):
            var args = effect.resolve_args(context)

            _resolve_keyword(effect.keyword, args)
    
    return true

func _resolve_keyword(keyword: String, args: Array[Variant]):
    # Take before snapshots for all Atom arguments
    # Call the keyword
    var operation_tree = Keywords.create_operation_tree(keyword, args)

    var result = operation_tree.resolve()

    keyword_resolved.emit(result)
