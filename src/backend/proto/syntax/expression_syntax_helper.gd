class_name ExpressionSyntaxHelper
extends Resource

static func syntactic_sugar(expr: String) -> String:
    expr = replace_logical_operators(expr)
    expr = replace_assignment_equals(expr)
    expr = replace_ternary(expr)
    
    return expr


static func replace_logical_operators(expr: String) -> String:
    expr = expr.replace(" AND ", " and ")
    expr = expr.replace(" OR ", " or ")
    return expr

static func replace_assignment_equals(expr: String) -> String:
    # Replace = with == (but not in ==, >=, <=, !=)
    var eq_regex = RegEx.new()
    eq_regex.compile("(?<![=<>!])=(?!=)")
    return eq_regex.sub(expr, "==", true)

static func replace_ternary(expr: String) -> String:
    var ternary_regex = RegEx.new()
    ternary_regex.compile("(.+?)\\s*\\?\\s*(.+?)\\s*:\\s*(.+)")
    var ternary_match = ternary_regex.search(expr)
    if ternary_match:
        var condition = ternary_match.get_string(1).strip_edges()
        var true_value = ternary_match.get_string(2).strip_edges()
        var false_value = ternary_match.get_string(3).strip_edges()
        return "select(%s, %s, %s)" % [condition, true_value, false_value]
    return expr