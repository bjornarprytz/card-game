class_name CleanupStepDefinition
extends StepDefinition

static var KEYWORD: String = &"cleanup_step"

func _get_keyword() -> String:
	return KEYWORD

func cleanup_step() -> Array[Operation]:
	var operations: Array[Operation] = [NoopOperation.new()]

	for effect_handle in _game_state.scope_provider.get_static_effects_queued_for_cleanup():
		operations.append(RemoveStaticEffect.new(effect_handle))

	return operations
