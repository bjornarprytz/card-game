class_name NoopOperation
extends Operation

func _init() -> void:
    # No initialization needed for a noop operation
    pass

func execute() -> Array[StateChange]:
    # No state changes for a noop operation
    return []