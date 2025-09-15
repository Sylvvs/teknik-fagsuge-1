extends Node2D
class_name State

@onready var debug = owner.find_child("debug")
@onready var room_handler = get_tree().root.get_node("RoomHandler")
@onready var player = null;
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready():
	call_deferred("_find_player")
	set_physics_process(false)

func _find_player():
	for child in room_handler.get_children():
		if child.is_in_group("player"):
			player = child.get_node("CharacterBody2D")

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass
	#var distance = owner.direction.length()
	#
	#if distance > 30:
		#get_parent().change_state("Follow")

func _physics_process(_delta):
	transition()
	debug.text = name
