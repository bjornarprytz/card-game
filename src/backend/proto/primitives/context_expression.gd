class_name ContextExpression
extends Resource

## A class for parsing and evaluating expressions with special syntax for game state access.
##
## SYNTAX GUIDE:
## -------------
## 1. TARGET ACCESS:
##    - t0, t1, t2, etc.: Access targets by index from the context's player_choices["targets"] array
##    - t0.health, t1.armor, etc.: Access properties of targets
##
## 2. VARIABLE ACCESS:
##    - $variable_name: Access variables in the context using $ prefix
##    - variable_name: Simple variable names without operators are also interpreted as variables
##
## 3. OPERATORS:
##    - Arithmetic: +, -, *, /, % (modulo)
##    - Comparison: >, <, >=, <=, ==, != (or <>)
##    - Logical: AND, OR, and, or (both forms supported)
##    - Assignment: = is automatically converted to == for comparisons
##
## 4. TERNARY EXPRESSIONS:
##    - condition ? true_value : false_value
##    - Example: t0.health > 5 ? 10 : 5
##
## 5. CONSTANTS:
##    - true, false: Boolean values
##    - Numbers: 1, 2, 3.14, etc.
##    - Strings: "text" (must be quoted)
##
## EXAMPLES:
## ---------
## - "t0.health > 5": Checks if target 0's health is greater than 5
## - "t0.armor == 0 AND t0.health < 3": Combines conditions with AND
## - "$damage + 2": Adds 2 to the 'damage' variable
## - "t0.health > 3 ? t0.health : 3": Returns target's health if > 3, otherwise returns 3

var expression_string: String = ""
var _expression: Expression = Expression.new()
var _is_parsed: bool = false
var _helper: ContextExpressionHelper = ContextExpressionHelper.new()

# Initialize with an expression string
func _init(expr_string: String = ""):
	expression_string = expr_string
	if not expr_string.is_empty():
		parse()

# Parse the expression
func parse() -> bool:
	if expression_string.is_empty():
		return false
		
	var error = _expression.parse(expression_string, ["context"])
	if error != OK:
		push_error("Error parsing expression: %s\nError: %s" % [expression_string, _expression.get_error_text()])
		return false
		
	_is_parsed = true
	return true

# Evaluate the expression with the given context
func evaluate(context: Context) -> Variant:
	if expression_string.is_empty():
		return null
		
	if not _is_parsed and not parse():
		return null
		
	# Pass the helper instance as base_instance
	_helper.set_context(context)
	var result = _expression.execute([context], _helper)
	if _expression.has_execute_failed():
		push_error("Error executing expression: %s\nError: %s" % [expression_string, _expression.get_error_text()])
		return null
		
	return result

# Create a context expression from a string, processing syntactic sugar
static func from_string(raw_expression: String) -> ContextExpression:
	if raw_expression.is_empty():
		return null
		
	# Process the expression to replace shortcuts
	var processed_expression = raw_expression
	
	# Replace standalone target references (t0, t1, etc. without property accessors)
	var standalone_target_regex = RegEx.new()
	standalone_target_regex.compile("\\bt(\\d+)\\b")
	var matches = standalone_target_regex.search_all(processed_expression)
	for regex_match in matches:
		var target_index = regex_match.get_string(1)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"t(%s)" % target_index
		)
	
	# Replace target references with property accessors (t0.health, t1.armor, etc.)
	var target_property_regex = RegEx.new()
	target_property_regex.compile("\\bt(\\d+)\\.")
	matches = target_property_regex.search_all(processed_expression)
	for regex_match in matches:
		var target_index = regex_match.get_string(1)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"t(%s)." % target_index
		)
	
	# Replace variable references with $ prefix
	var var_regex = RegEx.new()
	var_regex.compile("\\$([a-zA-Z_][a-zA-Z0-9_]*)")
	matches = var_regex.search_all(processed_expression)
	for regex_match in matches:
		var var_name = regex_match.get_string(1)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"v(\"%s\")" % var_name
		)
	
	# Check if the expression is just a simple variable name (no operators or functions)
	var simple_var_regex = RegEx.new()
	simple_var_regex.compile("^[a-zA-Z_][a-zA-Z0-9_]*$")
	if simple_var_regex.search(processed_expression):
		# It's a simple variable name without $ prefix
		processed_expression = "v(\"%s\")" % processed_expression
	
	# Replace logical operators
	processed_expression = processed_expression.replace(" AND ", " and ")
	processed_expression = processed_expression.replace(" OR ", " or ")
	
	# Only replace standalone = with == (not in ==, >=, <=)
	var eq_regex = RegEx.new()
	eq_regex.compile("(?<![=<>])=(?!=)")
	processed_expression = eq_regex.sub(processed_expression, "==", true)
	
	# Finally, replace ternary operators (condition ? true_value : false_value) with GDScript's if expression
	# This needs to happen last, after all other transformations
	var ternary_regex = RegEx.new()
	ternary_regex.compile("(.+?)\\s*\\?\\s*(.+?)\\s*:\\s*(.+)")
	var ternary_match = ternary_regex.search(processed_expression)
	if ternary_match:
		var condition = ternary_match.get_string(1).strip_edges()
		var true_value = ternary_match.get_string(2).strip_edges()
		var false_value = ternary_match.get_string(3).strip_edges()
		
		# Use our custom select function to implement ternary behavior
		processed_expression = "select(%s, %s, %s)" % [condition, true_value, false_value]
	
	return ContextExpression.new(processed_expression)

# Helper functions that will be available in the expression context
static func t(context: Context, index: int) -> Variant:
	var chosen_targets = context.player_choices.get("targets", [])

	if index >= 0 and index < chosen_targets.size():
		return chosen_targets[index]
	push_error("Target index out of bounds: %d" % index)
	return null

static func v(context: Context, var_name: String) -> Variant:
	if context.vars.has(var_name):
		return context.vars[var_name].resolve(context)
	push_error("Variable not found: %s" % var_name)
	return null
	
# Helper function to implement ternary operator behavior
static func select(condition: bool, true_value: Variant, false_value: Variant) -> Variant:
	if condition:
		return true_value
	else:
		return false_value

# Helper class to provide instance methods for expression evaluation
class ContextExpressionHelper extends RefCounted:
	var _context: Context = null
	
	func set_context(context: Context) -> void:
		_context = context
	
	func t(index: int) -> Variant:
		return ContextExpression.t(_context, index)
	
	func v(var_name: String) -> Variant:
		return ContextExpression.v(_context, var_name)
	
	func select(condition: bool, true_value: Variant, false_value: Variant) -> Variant:
		return ContextExpression.select(condition, true_value, false_value)
