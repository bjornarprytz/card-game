class_name ContextExpression
extends Resource

## A class for parsing and evaluating expressions with special syntax for game state access.
##
## SYNTAX GUIDE:
## -------------
## 1. TARGET ACCESS:
##    - t0, t1, t2, etc.: Access targets by index from the context's prompt["targets"] array
##    - t0.health, t1.armor, etc.: Access properties of targets
##
## 2. VARIABLE ACCESS:
##    - $variable_name: Access variables in the context using $ prefix (shorthand for @vars.variable_name)
##    - @vars.x: Direct access to context.vars.x
##    - @prompt.cards_to_discard: Direct access to context.prompt.cards_to_discard
##    - @state.hand.atoms: Direct access to context.state.hand.atoms
##    - #prompt_binding: Shorthand for @prompt.prompt_binding
##    - :state_path: Shorthand for @state.state_path
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
## - "@vars.x + 2": Direct access to variable x
## - "@prompt.cards_to_discard.size()": Access prompt binding
## - "@state.hand.atoms.size()": Access game state
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
	
	var processed_expression = raw_expression

	# Replace @context access: @vars.x, @prompt.cards_to_discard, @state.hand.atoms
	var at_regex = RegEx.new()
	at_regex.compile("@([a-zA-Z_][a-zA-Z0-9_]*)((?:\\.[a-zA-Z_][a-zA-Z0-9_\\.]*)*)")
	var matches = at_regex.search_all(processed_expression)
	for regex_match in matches:
		var context_key = regex_match.get_string(1)
		var path = regex_match.get_string(2)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"context.%s%s" % [context_key, path]
		)

	# Replace $var with context.vars.var
	var var_regex = RegEx.new()
	var_regex.compile("\\$([a-zA-Z_][a-zA-Z0-9_]*)")
	matches = var_regex.search_all(processed_expression)
	for regex_match in matches:
		var var_name = regex_match.get_string(1)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"v(\"%s\")" % var_name
		)

	# Replace #prompt_binding with context.prompt.prompt_binding
	var prompt_regex = RegEx.new()
	prompt_regex.compile("#([a-zA-Z_][a-zA-Z0-9_]*)")
	matches = prompt_regex.search_all(processed_expression)
	for regex_match in matches:
		var prompt_name = regex_match.get_string(1)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"p(\"%s\")" % prompt_name
		)

	# Replace :state_path with context.state.state_path
	var state_regex = RegEx.new()
	state_regex.compile(":([a-zA-Z_][a-zA-Z0-9_\\.]*)")
	matches = state_regex.search_all(processed_expression)
	for regex_match in matches:
		var state_path = regex_match.get_string(1)
		processed_expression = processed_expression.replace(
			regex_match.get_string(),
			"context.state.%s" % state_path
		)

	# Replace standalone target references (t0, t1, etc. without property accessors)
	var standalone_target_regex = RegEx.new()
	standalone_target_regex.compile("\\bt(\\d+)\\b")
	matches = standalone_target_regex.search_all(processed_expression)
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

	# Check if the expression is just a simple variable name (no operators or functions)
	var simple_var_regex = RegEx.new()
	simple_var_regex.compile("^[a-zA-Z_][a-zA-Z0-9_]*$")
	if simple_var_regex.search(processed_expression):
		# It's a simple variable name without $ prefix
		processed_expression = "context.vars.%s" % processed_expression

	# Apply reusable syntax helpers
	processed_expression = ExpressionSyntaxHelper.syntactic_sugar(processed_expression)

	return ContextExpression.new(processed_expression)

func _to_string() -> String:
	if expression_string.is_empty():
		return "<Empty Context Expression>"
	return expression_string

# Helper functions that will be available in the expression context
static func t(context: Context, index: int) -> Variant:
	var chosen_targets = p(context, "targets")

	if (chosen_targets is not Array):
		push_error("Expected context.prompt.targets to be an array, got: %s" % typeof(chosen_targets))
		return null

	if index >= 0 and index < chosen_targets.size():
		return chosen_targets[index]
	push_error("Target index out of bounds: %d" % index)
	return null

static func v(context: Context, var_name: String) -> Variant:
	if context.vars.has(var_name):
		return context.vars[var_name].resolve(context)
	push_error("Variable not found: %s" % var_name)
	return null

static func p(context: Context, binding_key: String) -> Variant:
	if context.prompt.has(binding_key):
		return context.prompt[binding_key]
	push_error("Prompt binding not found: %s" % binding_key)
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

	func p(binding_key: String) -> Variant:
		return ContextExpression.p(_context, binding_key)

	func select(condition: bool, true_value: Variant, false_value: Variant) -> Variant:
		return ContextExpression.select(condition, true_value, false_value)
