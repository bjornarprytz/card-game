## A Prompt is something that requires action from the player in the during an effect block.
class_name Prompt
extends Resource

var prompt_bindings: Array[PromptBindingProto] = []
var _context: Context

func _init(prompt_bindings_: Array[PromptBindingProto], context: Context) -> void:
    prompt_bindings = prompt_bindings_
    _context = context

func validate_response(_response: PromptResponse) -> bool:
    push_error("validate_response not implemented in base Prompt class")
    return false

func try_resolve(_response: PromptResponse) -> bool:
    push_error("try_resolve not implemented in base Prompt class")
    # This method should be overridden by subclasses to handle the action resolution
    return false