extends Node
class_name BatState

@export var enemy: CharacterBody2D
@onready var player : Node2D = null
@onready var anim = $"../../Animation handler Bat/AnimationPlayer"

signal Transitioned

func enter():
	pass

func exit():
	pass
	
func update(delta: float):
	pass
	
func physics_update(delta: float) -> State:
	return null
