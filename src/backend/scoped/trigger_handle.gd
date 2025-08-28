class_name TriggerHandle
extends StaticEffectHandle

var trigger: Trigger
var times_triggered: int = 0

func _init(trigger_: Trigger, scope_: Scope, source_: Atom) -> void:
	super._init(scope_, source_, trigger_)
	trigger = trigger_

func check(event: Event) -> Array[EffectBlock]:
	var context = TriggerContext.new(self, event)

	if not trigger.condition.evaluate(context):
		return []

	if (event.inner_context is TriggerContext):
		push_error("Nested triggers are risky. Consider doing something")

	times_triggered += 1

	return [TriggerBlock.new(context)]

func remove() -> void:
	push_error("Reminder: Do something when trigger is removed?")
