extends Node

static func pay_resources(state: GameState, amount: int) -> PaymentResult:
    assert(state.player.resources >= 0, "Player resources should not be negative")
    
    if state.player.resources < amount:
        push_warning("Not enough resources to pay %d, current resources: %d" % [amount, state.player.resources])
        return PaymentResult.failure()

    return PaymentResult.success(
        Keywords.create_operation_tree("lose_resources", [state.player, amount])
    )
