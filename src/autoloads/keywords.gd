extends Node

func damage(target: Creature, amount: int):
    target.armor -= amount
    
    if (target.armor < 0):
        target.health += target.armor
        target.armor = 0

func add_armor(target: Creature, amount: int):
    target.armor += amount

func create_card(card_name: String, zone: Zone):
    var atom = Create.card(card_name)
    zone.add_atom(atom)

func create_creature(creature_name: String, zone: Zone):
    var atom = Create.creature(creature_name)
    zone.add_atom(atom)

func change_zone(atom: Atom, new_zone: Zone):
    if atom.current_zone == new_zone:
        push_warning("Atom <%s> is already in zone <%s>" % [atom.name, new_zone.name])
        return

    if atom.current_zone != null:
        atom.current_zone.remove_atom(atom)

    new_zone.add_atom(atom)
    atom.current_zone = new_zone
