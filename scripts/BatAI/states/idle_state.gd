extends BatState
class_name BatIdle

@export var enemy: CharacterBody2D
@onready var player : Node2D = null
@onready var anim = $"../../Animation handler Bat/AnimationPlayer"

func enter():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player = player.get_node("CharacterBody2D")
	anim.play('idle')
	enemy.velocity = Vector2.ZERO
	
func physics_update(delta: float):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < 80:
		Transitioned.emit(self,'BatChase')
