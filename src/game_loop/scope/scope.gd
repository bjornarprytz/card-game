class_name Scope
extends Resource

enum ScopeLifecycle {
    LATENT,
    OPEN,
    CLOSED
}

var scope_name: String

var _lifecycle: ScopeLifecycle = ScopeLifecycle.LATENT

var results: Array[KeywordResult] = []
var modifiers: Array[ModifierHandle] = []

func add_result(new_result: KeywordResult) -> void:
    results.append(new_result)

func add_modifier(new_modifier: ModifierHandle) -> void:
    if (_lifecycle == ScopeLifecycle.CLOSED):
        push_error("%s is closed" % scope_name)

    modifiers.append(new_modifier)

    if (_lifecycle == ScopeLifecycle.OPEN):
        new_modifier.apply()
        

func _init(scope_name_: String) -> void:
    scope_name = scope_name_

func open() -> void:
    if (_lifecycle == ScopeLifecycle.LATENT):
        _lifecycle = ScopeLifecycle.OPEN
    else:
        push_error("%s has already been opened" % scope_name)

    for modifier in modifiers:
        modifier.apply()

func close() -> void:
    if (_lifecycle == ScopeLifecycle.OPEN):
        _lifecycle = ScopeLifecycle.CLOSED
    else:
        push_error("%s is not open" % scope_name)

    for modifier in modifiers:
        modifier.remove()

func _to_string() -> String:
    return scope_name
