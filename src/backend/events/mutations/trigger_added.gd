class_name TriggerAdded
extends Mutation

var trigger: Trigger

func _init(host_: Atom, trigger_: Trigger) -> void:
    atom = host_
    trigger = trigger_

func _to_string() -> String:
    return "%s¤%s" % [atom, trigger]