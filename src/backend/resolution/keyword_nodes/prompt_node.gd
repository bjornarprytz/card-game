class_name PromptNode
extends KeywordNode

var _context: Context

var _prompt_proto: PromptProto

func _init(prompt_proto: PromptProto) -> void:
    keyword = "prompt"
    args = []
    _prompt_proto = prompt_proto

static func from_args(args_: Array[Variant]) -> PromptNode:
    ## TODO: Factory for creating a prompt node from arguments
    if args_.size() != 1:
        push_error("PromptNode requires exactly one argument.")

    var prompt_proto = args_[0]
    if not prompt_proto is PromptProto:
        push_error("PromptNode argument must be a PromptProto.")
        return null
        
    return PromptNode.new(prompt_proto)

func _resolve_internal() -> KeywordResult:
    var result = KeywordResult.new(keyword, args)
    
    return result


func create_prompt(context: Context) -> Prompt:
    return Prompt.new(_prompt_proto.prompt_bindings.values(), context)
