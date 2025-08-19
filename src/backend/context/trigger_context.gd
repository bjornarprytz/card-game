class_name TriggerContext
extends Context

var event: Event
var trigger: TriggerHandle

func _init(trigger_: TriggerHandle, event_: Event) -> void:
    trigger = trigger_
    event = event_
    super._init(event_.inner_context.game_state, event_.inner_context.source)