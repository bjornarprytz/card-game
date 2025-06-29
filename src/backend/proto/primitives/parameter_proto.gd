class_name ParameterProto
extends Resource

var _immediate: Variant = null
var _expression: ContextExpression = null
var _accessor: Callable

func get_value(context: Context) -> Variant:
    # If we have an expression, evaluate it
    if (_expression != null):
        return _expression.evaluate(context)
    
    if (_accessor != null):
        var result = _accessor.call(context)
        if result is Variant:
            return result
        push_error("Error: Accessor did not return a valid Variant")
        return null
    
    if (_immediate != null):
        return _immediate
    
    push_error("Error: No immediate value or accessor found")
    return null

static func from_variant(param: Variant) -> ParameterProto:
    var parameter = ParameterProto.new()

    if param is int:
        parameter._immediate = param
    elif param is bool:
        parameter._immediate = param
    elif param is float:
        parameter._immediate = param
    elif param is String:
        # If the string is quoted, treat it as an immediate string value
        if param.begins_with("\"") and param.ends_with("\"") and param.length() >= 2:
            # Remove the quotes and treat as immediate string
            parameter._immediate = param.substr(1, param.length() - 2)
        else:
            # Otherwise, treat it as an expression
            parameter._expression = ContextExpression.from_string(param)
    
    return parameter

## Expects a callable that takes a Context and returns a Variant
static func from_callable(callable: Callable) -> ParameterProto:
    var parameter = ParameterProto.new()
    
    if callable.is_null():
        push_error("Error: Callable is null")
        return parameter

    parameter._accessor = callable
    return parameter