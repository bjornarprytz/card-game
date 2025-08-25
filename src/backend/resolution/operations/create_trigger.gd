class_name CreateTrigger
extends Operation

var scope: Scope
var trigger: Trigger
var host: Atom

func _init(trigger_: Trigger, host_: Atom, scope_: Scope) -> void:
    trigger = trigger_
    host = host_
    scope = scope_

func execute() -> Array[Mutation]:
    var handle = TriggerHandle.new(trigger, scope, host)
    scope.add_trigger(handle)

    return [Mutation.trigger_added(host, trigger)]