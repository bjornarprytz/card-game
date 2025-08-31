class_name Scope
extends Resource

enum ScopeLifecycle {
	LATENT,
	OPEN,
	CLOSED
}

var scope_name: String

var _lifecycle: ScopeLifecycle = ScopeLifecycle.LATENT

var events: Array[Event] = []
var static_effects: Array[StaticEffectHandle] = []

func process_event(new_event: Event) -> Array[EffectBlock]:
	events.append(new_event)

	var triggered_effects: Array[EffectBlock] = []

	for static_effect in static_effects:
		triggered_effects.append_array(static_effect.on_event(new_event))

	return triggered_effects

func get_static_effects_queued_for_cleanup() -> Array[StaticEffectHandle]:
	var effects_queued_for_cleanup: Array[StaticEffectHandle] = []
	for static_effect in static_effects:
		if static_effect.is_queued_for_cleanup:
			effects_queued_for_cleanup.append(static_effect)
	return effects_queued_for_cleanup

func add_static_effect(new_effect: StaticEffectHandle) -> void:
	if (_lifecycle != ScopeLifecycle.OPEN):
		push_error("%s is not open" % scope_name)
		return

	static_effects.append(new_effect)
	new_effect.setup()

func remove_static_effect(effect_handle: StaticEffectHandle) -> void:
	if (_lifecycle != ScopeLifecycle.OPEN):
		push_error("%s is not open" % scope_name)
		return

	static_effects.erase(effect_handle)
	effect_handle.finish_cleanup()

func refresh(game_state: GameState) -> void:
	for static_effect in static_effects:
		static_effect.update(game_state)

func _init(scope_name_: String) -> void:
	scope_name = scope_name_

func turn_tick() -> Array[EffectBlock]:
	if _lifecycle != ScopeLifecycle.OPEN:
		push_error("%s is not open" % scope_name)
		return []

	var triggered_effects: Array[EffectBlock] = []

	for static_effect in static_effects:
		triggered_effects.append_array(static_effect.turn_tick())

	return triggered_effects

func open() -> void:
	if (_lifecycle == ScopeLifecycle.LATENT):
		_lifecycle = ScopeLifecycle.OPEN
	else:
		push_error("%s has already been opened" % scope_name)
	
	assert(static_effects.is_empty(), "Scope opened with existing static effects. Was this intended?")

func close() -> void:
	if (_lifecycle == ScopeLifecycle.OPEN):
		_lifecycle = ScopeLifecycle.CLOSED
	else:
		push_error("%s is not open" % scope_name)

	for static_effect in static_effects:
		if (static_effect.is_active):
			static_effect.queue_cleanup()

func _to_string() -> String:
	return scope_name
