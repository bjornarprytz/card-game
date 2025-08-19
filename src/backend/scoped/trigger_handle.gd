class_name TriggerHandle
extends ScopedEffectHandle

var condition: ContextConditionProto
var effects: Array[EffectProto] = []

var times_triggered: int = 0

func check(event: Event) -> TriggerContext:
    var context = TriggerContext.new(self, event)
    
    if not condition.evaluate(context):
        return null

    times_triggered += 1

    return context

func remove() -> void:
    push_error("Reminder: Do something when trigger is removed?")