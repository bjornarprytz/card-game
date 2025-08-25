class_name Operation
extends Resource

func execute() -> Array[Mutation]:
	# This method should be overridden in subclasses
	push_error("Operation.execute() must be overridden in subclasses")
	return []
