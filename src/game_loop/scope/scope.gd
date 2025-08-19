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
var modifiers: Array[ModifierHandle] = []
var triggers: Array[TriggerHandle] = []

func add_event(new_event: Event) -> Array[TriggerContext]:
	events.append(new_event)

	var triggered_effects: Array[TriggerContext] = []

	for trigger in triggers:
		var context = trigger.check(new_event)
		if context != null:
			triggered_effects.append(context)

	return triggered_effects

func add_trigger(new_trigger: TriggerHandle) -> void:
	triggers.append(new_trigger)

func add_modifier(new_modifier: ModifierHandle) -> void:
	if (_lifecycle == ScopeLifecycle.CLOSED):
		push_error("%s is closed" % scope_name)

	modifiers.append(new_modifier)

func refresh_modifiers(game_state: GameState) -> void:
	for modifier in modifiers:
		modifier.refresh_targets(game_state)

func _init(scope_name_: String) -> void:
	scope_name = scope_name_

func turn_tick() -> void:
	if _lifecycle != ScopeLifecycle.OPEN:
		push_error("%s is not open" % scope_name)
		return
	
	for modifier in modifiers:
		modifier.turn_tick()
	for trigger in triggers:
		trigger.turn_tick()


func open() -> void:
	if (_lifecycle == ScopeLifecycle.LATENT):
		_lifecycle = ScopeLifecycle.OPEN
	else:
		push_error("%s has already been opened" % scope_name)

	for modifier in modifiers:
		modifier.apply()

func close() -> void:
	if (_lifecycle == ScopeLifecycle.OPEN):
		_lifecycle = ScopeLifecycle.CLOSED
	else:
		push_error("%s is not open" % scope_name)

	for modifier in modifiers:
		modifier.remove()

	for trigger in triggers:
		trigger.remove()

func _to_string() -> String:
	return scope_name
