class_name KeywordNode
extends Resource

var keyword: String
var args: Array[Variant] = []

var _is_resolved: bool = false

static func create(keyword_: String, args_: Array[Variant], contents_: Array) -> KeywordNode:
    if contents_ is Array[Operation]:
        return OperationNode.new(keyword_, args_, contents_)
    elif contents_ is Array[KeywordNode]:
        return CompositeNode.new(keyword_, args_, contents_)
    else:
        push_error("Invalid contents type for KeywordNode creation")
        return null

static func noop(keyword_: String) -> KeywordNode:
    return KeywordNode.create(keyword_, [], [])

func resolve() -> KeywordResult:
    assert(!_is_resolved, "KeywordNode has already been resolved")

    var result = _resolve_internal()

    _is_resolved = true
    return result

func _resolve_internal() -> KeywordResult:
    push_error("KeywordNode._resolve_internal should be implemented.")
    return null
