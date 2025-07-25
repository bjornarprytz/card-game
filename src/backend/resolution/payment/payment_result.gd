class_name PaymentResult
extends Resource

var is_valid: bool = false

var operation_tree: KeywordNode

static func success(operation_tree_: KeywordNode) -> PaymentResult:
    var result = PaymentResult.new()
    result.operation_tree = operation_tree_
    result.is_valid = true
    return result

static func failure() -> PaymentResult:
    var result = PaymentResult.new()
    result.is_valid = false
    return result
