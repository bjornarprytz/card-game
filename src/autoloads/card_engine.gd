class_name CardEngine
extends Node2D

var _cards: Dictionary[String, CardData] = {}

var _atoms: Dictionary[String, Atom] = {}

func _ready() -> void:
	for card in Cards.load_card_data():
		add_card(card)

static func bind_resolver(play_context: PlayContext) -> Array[Callable]:
	var card = play_context.card
	var targets = play_context.chosen_targets
	
	var resolvers: Array[Callable] = []
	
	var methods = Keywords.new().get_method_list()
	
	resolvers.push_back(Keywords.callv.bind("add_armor", [play_context.targets[0], 2]))
	
#   for effect in card_data.effects:
#       for method in methods:
#           if effect.keyword == method["name"]:
#               var arguments: Array[Variant] = []
#               for param in effect.arguments:
#                   arguments.push_back(param.get_value(play_context))
#               resolvers.push_back(Keywords.callv.bind(effect.keyword, arguments))
		
	return resolvers

func add_atom() -> Atom:
	var atom = preload("res://atom.tscn").instantiate() as Atom
	atom.id = OS.get_unique_id()
	print(atom.id)
	add_child(atom)
	_atoms[atom.id] = atom
	
	return atom

func get_atom(id: String) -> Atom:
	if (!_atoms.has(id)):
		return null
	return _atoms[id]

func add_card(card: CardData):
	_cards[card.name] = card

func get_card(id: String) -> CardData:
	if (!_cards.has(id)):
		return null
	return _cards[id]

func get_cards() -> Array[CardData]:
	return _cards.values()
