class_name CleanupStepDefinition
extends KeywordDefinition

static var KEYWORD: String = &"cleanup_step"

func _get_keyword() -> String:
    return KEYWORD

func cleanup_step() -> Array[Operation]:
    var operations: Array[Operation] = []

    for effect_handle in _dependencies.game_state.scope_provider.get_static_effects_queued_for_cleanup():
        operations.append(RemoveStaticEffect.new(effect_handle))

    if operations.is_empty():
        return [NoopOperation.new()]

    return operations
