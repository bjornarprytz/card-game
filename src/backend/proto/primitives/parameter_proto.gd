class_name ParameterProto
extends Resource

var _immediate: Variant = null
var _expression: ContextExpression = null

func get_value(context: Context) -> Variant:
    # If we have an expression, evaluate it
    if (_expression != null):
        return _expression.evaluate(context)
    
    if (_immediate != null):
        return _immediate
    
    push_error("Error: No immediate value or context expression found")
    return null

static func from_variant(param: Variant) -> ParameterProto:
    var parameter = ParameterProto.new()

    if param is String:
        # If the string is quoted, treat it as an immediate string value
        if param.begins_with("\"") and param.ends_with("\"") and param.length() >= 2:
            # Remove the quotes and treat as immediate string
            parameter._immediate = param.substr(1, param.length() - 2)
        else:
            # Otherwise, treat it as an expression
            parameter._expression = ContextExpression.from_string(param)
    else:
        # If it's not a context expression, treat it as an immediate value
        parameter._immediate = param
    
    return parameter
