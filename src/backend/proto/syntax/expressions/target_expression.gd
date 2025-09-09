class_name TargetExpression
extends SimpleExpression

var target_index: int

func _init(index: int):
    super._init("t%d" % index)
    target_index = index