class_name GameTurn
extends Resource

var turn_number: int = 0
var phases: Array[GamePhase] = []

func _init(turn_number_: int) -> void:
    turn_number = turn_number_
    phases = [
        
    ]