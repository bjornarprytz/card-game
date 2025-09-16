class_name PayResourcesDefinition
extends PaymentDefinition

static var KEYWORD: String = &"pay_resources"

func _get_keyword() -> String:
    return KEYWORD

func pay_resources(amount: int) -> PaymentResult:
    if _game_state.player.resources < amount:
        push_warning("Not enough resources to pay %d, current resources: %d" % [amount, _game_state.player.resources])
        return PaymentResult.failure()

    return PaymentResult.success(
        _kw_node(LoseResourcesDefinition.KEYWORD, [_game_state.player, amount])
    )
