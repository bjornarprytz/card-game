class_name CreateTrigger
extends Operation

var scope: Scope
var trigger: Trigger
var source: Atom

func _init(trigger_: Trigger, source_: Atom, scope_: Scope) -> void:
    trigger = trigger_
    source = source_
    scope = scope_

func execute() -> Array[StateChange]:
    var handle = TriggerHandle.new(trigger, scope, source)
    scope.add_trigger(handle)

    return [StateChange.trigger(source)]