class_name StaticEffectProto
extends EffectProto


enum ScopeLevel {
	BLOCK,
	TURN,
	GLOBAL
}
## The lifetime of the modifier
var scope: ScopeLevel

## The atom from which the modifier originates
var source: ContextExpression
