class_name Event
extends Resource

var inner_context: Context
var result: KeywordResult

func _init(result_: KeywordResult, context_: Context) -> void:
	result = result_
	inner_context = context_

func state_changed(atom: Atom, state_key: String) -> bool:
	for mutation in result.get_mutations():
		if mutation is StateChange:
			if mutation.atom == atom and mutation.state_key == state_key:
				return true
	return false
