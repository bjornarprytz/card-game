class_name TriggerContext
extends Context

var event: Event
var trigger: TriggerHandle


func _init(trigger_: TriggerHandle, event_: Event) -> void:
	super._init(event_.inner_context.state, event_.inner_context.source)
	trigger = trigger_
	event = event_
	
