class_name AtomExpression
extends Resource

## A class for parsing and evaluating expressions with an Atom as context.

var expression_string: String = ""
var _expression: Expression = Expression.new()
var _is_parsed: bool = false

# Initialize with an expression string
func _init(expr_string: String = ""):
    expression_string = expr_string
    if not expr_string.is_empty():
        parse()

# Parse the expression
func parse() -> bool:
    if expression_string.is_empty():
        return false
    var error = _expression.parse(expression_string, ["atom"])
    if error != OK:
        push_error("Error parsing atom expression: %s\nError: %s" % [expression_string, _expression.get_error_text()])
        return false
    _is_parsed = true
    return true

# Evaluate the expression with the given atom
func evaluate(atom: Atom) -> Variant:
    if expression_string.is_empty():
        return null
    if not _is_parsed and not parse():
        return null
    var result = _expression.execute([atom])
    if _expression.has_execute_failed():
        push_error("Error executing atom expression: %s\nError: %s" % [expression_string, _expression.get_error_text()])
        return null
    return result

# Create an atom expression from a string (no shorthand syntax yet)
static func from_string(raw_expression: String) -> AtomExpression:
    if raw_expression.is_empty():
        return null

    var processed_expression = ExpressionSyntaxHelper.syntactic_sugar(raw_expression)
    
    return AtomExpression.new(processed_expression)