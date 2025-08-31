class_name TriggerHandle
extends StaticEffectHandle

var trigger: Trigger
var times_triggered: int = 0

func _init(trigger_: Trigger, scope_: Scope, source_: Atom) -> void:
	super._init(scope_, source_, trigger_)
	trigger = trigger_

func _on_event_internal(event: Event) -> Array[EffectBlock]:
	var context = TriggerContext.new(self, event)

	if not trigger.condition.evaluate(context):
		return []

	if (event.inner_context is TriggerContext):
		push_error("Nested triggers are risky. Consider doing something")

	times_triggered += 1

	var triggered_effects: Array[EffectBlock] = [TriggerBlock.new(context)]

	if times_triggered == trigger.trigger_limit:
		print("trigger limit reached!")
		triggered_effects.append_array(queue_cleanup())

	return triggered_effects
