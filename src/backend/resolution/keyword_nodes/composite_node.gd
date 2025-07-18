class_name CompositeNode
extends KeywordNode

var sub_nodes: Array[KeywordNode] = []

func _init(keyword_: String, args_: Array[Variant], sub_nodes_: Array[KeywordNode]):
    keyword = keyword_
    args = args_
    sub_nodes = sub_nodes_

    is_terminal = false

    if sub_nodes_.is_empty():
        push_error("CompositeNode must have at least one sub-node")
    else:
        sub_nodes = sub_nodes_.duplicate()

func _resolve_internal() -> KeywordResult:
    var result = KeywordResult.new(keyword, args)

    for sub_node in sub_nodes:
        var sub_result = sub_node.resolve()
        result.add_sub_result(sub_result)

    return result