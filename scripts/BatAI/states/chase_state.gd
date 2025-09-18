extends BatState
class_name BatChase

@export var enemy: CharacterBody2D
@export var move_speed := 80.0
@onready var player : Node2D = null
@onready var anim = $"../../Animation handler Bat/AnimationPlayer"

var direction = Vector2.ZERO

func enter():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player = player.get_node("CharacterBody2D")
		anim.play('fly')
func physics_update(delta: float):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	direction = player.global_position - enemy.global_position
	
	if direction.length() > 35:
		enemy.velocity = direction.normalized() * move_speed
	else:
		Transitioned.emit(self,'BatAttack1')
	if direction.length() > 250:
		Transitioned.emit(self,'BatIdle')
