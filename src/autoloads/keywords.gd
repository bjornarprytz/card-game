extends Node

func damage(target: Creature, amount: int):
    target.armor -= amount
    
    if (target.armor < 0):
        target.health += target.armor
        target.armor = 0

func add_armor(target: Creature, amount: int):
    target.armor += amount

func create_atom(atom_name: String, atom_type: String, zone: Zone):
    var atom = Create.atom(atom_name, atom_type)

    change_zone(atom, zone)

func change_zone(atom: Atom, new_zone: Zone):
    if atom.current_zone != null:
        atom.current_zone.remove_atom(atom)

    new_zone.add_atom(atom)
    atom.current_zone = new_zone

## TODO: Tackle the concept of Composite Keywords. They will not resolve directly, but unwrap to a list of atomic keywords that will be executed in order.
## TODO: Calls to atomic keywords should be wrapped in a result builder, 
## TODO: The result builder can keep track of the GameState as well in order to catch atom creation