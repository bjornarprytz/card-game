class_name CardEngine
extends Node2D

class Card:
	var id : String
	var nTargets: int
	var bind_resolver: Callable
	
	func _init(id_ : String, nTargets_: int, bind_resolver_: Callable) -> void:
		id = id_
		nTargets = nTargets_
		bind_resolver = bind_resolver_

var _cards : Dictionary[String, Card] = {}

func add_card(card: Card):
	_cards[card.id] = card

func get_card(id: String) -> Card:
	if (!_cards.has(id)):
		return null
	return _cards[id]

func play(card: Card, targets: Array[Target]):
	print("Playing %s on %s targets" % [card.id, card.nTargets])
	var resolvers = card.bind_resolver.call(targets) as Array[Callable]
	for r in resolvers:
		print("Resolving: %s (%s)" % [r.get_method(), r.get_bound_arguments()])
		r.call()
	
