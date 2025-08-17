class_name CreateModifier
extends Operation

var scope: Scope
var modifier: Modifier
var targets: Array[Atom] = []


func execute() -> Array[StateChange]:
    var handle = ModifierHandle.new()


    ## TODO: Figure out what is created when and where. 
    ## TODO: Also, how does it map to a StateChange? Does StateChange need to be expanded for this?