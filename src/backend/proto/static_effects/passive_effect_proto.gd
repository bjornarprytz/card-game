class_name PassiveEffectProto
extends EffectProto

enum ScopeLevel {
    BLOCK,
    TURN,
    GLOBAL
}

## The lifetime of the modifier
var scope: ScopeLevel

## The atom from which the modifier originates
var host: ContextExpression

func _get_scope(context: Context) -> Scope:
    match scope:
        ScopeLevel.BLOCK:
            return context.scopes.block
        ScopeLevel.TURN:
            return context.scopes.turn
        ScopeLevel.GLOBAL:
            return context.scopes.global
        _:
            push_error("Invalid scope level %s" % scope)
            return null

func _get_host(context: Context) -> Atom:
    var host_atom = host.evaluate(context)
    assert(host_atom is Atom, "Host must be an Atom")
    return host_atom


static func parse_scope_level(scope_str: String) -> ScopeLevel:
    match scope_str.to_upper():
        "BLOCK":
            return ScopeLevel.BLOCK
        "TURN":
            return ScopeLevel.TURN
        "GLOBAL":
            return ScopeLevel.GLOBAL
        _:
            push_error("Error: Invalid scope level string: %s" % scope_str)
            return ScopeLevel.GLOBAL
