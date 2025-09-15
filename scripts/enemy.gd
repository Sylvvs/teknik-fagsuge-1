class_name EnemySignal_Enemy
extends Node2D

@onready var at : AnimationTree = $"AnimationTree"
@onready var playback = at["parameters/playback"]

func _ready():
	at.active = true


var health: int = 100:
	set(value):
		health = value
		if health <= 0:
			queue_free()

func apply_damage(amount : int):
	health -= amount
	at["parameters/conditions/hurting"] = true
	await get_tree().create_timer(0.8).timeout
	at["parameters/conditions/hurting"] = false
	
	

func update_animations():
	if Vector2.ZERO:
		at["parameters/conditions/idle"] = true
	else:
		pass

func _process(float):
	update_animations()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print('testing')
	if body.is_in_group('player'):
			body.take_damage(10)
	pass # Replace with function body.
