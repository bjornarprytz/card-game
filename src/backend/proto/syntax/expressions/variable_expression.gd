class_name VariableExpression
extends SimpleExpression

var variable_name: String

func _init(variable_name_: String):
	super._init("$%s" % variable_name_)
	variable_name = variable_name_
