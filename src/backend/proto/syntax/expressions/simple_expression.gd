class_name SimpleExpression
extends ContextExpression

## A simple expression that can be a standalone target, variable, or prompt key.
## It cannot access any properties or perform any operations.
func _init(raw_expression: String):
    var processed_expression = ExpressionSyntaxHelper.context_shorthands(raw_expression)
    super._init(processed_expression)

static func try_parse(raw_expression: String) -> SimpleExpression:
    var target_index = ExpressionSyntaxHelper.get_standalone_target_index(raw_expression)
    if target_index >= 0:
        return TargetExpression.new(target_index)

    var variable_name = ExpressionSyntaxHelper.get_standalone_var_name(raw_expression)
    if variable_name != "":
        return VariableExpression.new(variable_name)

    var prompt_key = ExpressionSyntaxHelper.get_standalone_prompt_key(raw_expression)
    if prompt_key != "":
        return PromptExpression.new(prompt_key)

    return null
