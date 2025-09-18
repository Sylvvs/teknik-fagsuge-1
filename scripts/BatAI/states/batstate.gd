extends Node
class_name BatState

signal Transitioned

func enter():
	pass

func exit():
	pass
	
func update(delta: float):
	pass
	
func physics_update(delta: float) -> State:
	return null
