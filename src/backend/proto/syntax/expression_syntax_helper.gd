class_name ExpressionSyntaxHelper
extends Resource

static func syntactic_sugar(expr: String) -> String:
    expr = replace_logical_operators(expr)
    expr = replace_assignment_equals(expr)
    expr = replace_ternary(expr)
    
    return expr


## Returns "var_name" if the expression is exactly "$var_name", else returns "".
static func get_standalone_var_name(expr: String) -> String:
    var simple_var_regex = RegEx.new()
    simple_var_regex.compile("^\\$([a-zA-Z_][a-zA-Z0-9_]*)$")
    var match = simple_var_regex.search(expr)
    
    if match:
        return match.get_string(1)
    return ""

## Returns 0, 1, 2 if the expression is exactly "t0", "t1", "t2" etc. else returns -1.
static func get_standalone_target_index(expr: String) -> int:
    var standalone_target_regex = RegEx.new()
    standalone_target_regex.compile("^t(\\d+)$")
    var match = standalone_target_regex.search(expr)
    
    if match:
        return int(match.get_string(1))
    return -1

static func get_standalone_prompt_key(expr: String) -> String:
    var simple_prompt_regex = RegEx.new()
    simple_prompt_regex.compile("^#([a-zA-Z_][a-zA-Z0-9_]*)$")
    var match = simple_prompt_regex.search(expr)
    
    if match:
        return match.get_string(1)
    return ""


static func context_shorthands(expr: String) -> String:
    # Replace @context access: @vars.x, @prompt.cards_to_discard, @state.hand.atoms
    var at_regex = RegEx.new()
    at_regex.compile("@([a-zA-Z_][a-zA-Z0-9_]*)((?:\\.[a-zA-Z_][a-zA-Z0-9_\\.]*)*)")
    var matches = at_regex.search_all(expr)
    for regex_match in matches:
        var context_key = regex_match.get_string(1)
        var path = regex_match.get_string(2)
        expr = expr.replace(
            regex_match.get_string(),
            "context.%s%s" % [context_key, path]
        )

    # Replace $var with context.vars.var
    var var_regex = RegEx.new()
    var_regex.compile("\\$([a-zA-Z_][a-zA-Z0-9_]*)")
    matches = var_regex.search_all(expr)
    for regex_match in matches:
        var var_name = regex_match.get_string(1)
        expr = expr.replace(
            regex_match.get_string(),
            "v(\"%s\")" % var_name
        )

    # Replace #prompt_binding with context.prompt.prompt_binding
    var prompt_regex = RegEx.new()
    prompt_regex.compile("#([a-zA-Z_][a-zA-Z0-9_]*)")
    matches = prompt_regex.search_all(expr)
    for regex_match in matches:
        var prompt_name = regex_match.get_string(1)
        expr = expr.replace(
            regex_match.get_string(),
            "p(\"%s\")" % prompt_name
        )

    # Replace :state_path with context.state.state_path
    var state_regex = RegEx.new()
    state_regex.compile(":([a-zA-Z_][a-zA-Z0-9_\\.]*)")
    matches = state_regex.search_all(expr)
    for regex_match in matches:
        var state_path = regex_match.get_string(1)
        expr = expr.replace(
            regex_match.get_string(),
            "context.state.%s" % state_path
        )

    # Replace standalone target references (t0, t1, etc. without property accessors)
    var standalone_target_regex = RegEx.new()
    standalone_target_regex.compile("\\bt(\\d+)\\b")
    matches = standalone_target_regex.search_all(expr)
    for regex_match in matches:
        var target_index = regex_match.get_string(1)
        expr = expr.replace(
            regex_match.get_string(),
            "t(%s)" % target_index
        )

    # Replace target references with property accessors (t0.health, t1.armor, etc.)
    var target_property_regex = RegEx.new()
    target_property_regex.compile("\\bt(\\d+)\\.")
    matches = target_property_regex.search_all(expr)
    for regex_match in matches:
        var target_index = regex_match.get_string(1)
        expr = expr.replace(
            regex_match.get_string(),
            "t(%s)." % target_index
        )

    # Check if the expression is just a simple variable name (no operators or functions)
    var simple_var_regex = RegEx.new()
    simple_var_regex.compile("^[a-zA-Z_][a-zA-Z0-9_]*$")
    if simple_var_regex.search(expr):
        # It's a simple variable name without $ prefix
        expr = "context.vars.%s" % expr
    
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
