extends Node2D
class_name State

@onready var debug = owner.find_child("debug")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var animation_player = owner.find_child("AnimationPlayer")

func _ready():
	set_physics_process(false)

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
