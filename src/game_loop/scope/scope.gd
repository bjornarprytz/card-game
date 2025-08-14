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

# TODO: Maybe static effects hang here (once they're implemented)


func _init(scope_name_: String) -> void:
	scope_name = scope_name_

func open() -> void:
	if (_lifecycle == ScopeLifecycle.LATENT):
		_lifecycle = ScopeLifecycle.OPEN
	else:
		push_error("%s is already open" % scope_name)

func close() -> void:
	if (_lifecycle == ScopeLifecycle.OPEN):
		_lifecycle = ScopeLifecycle.CLOSED
	else:
		push_error("%s is not open" % scope_name)

func _to_string() -> String:
	return scope_name
