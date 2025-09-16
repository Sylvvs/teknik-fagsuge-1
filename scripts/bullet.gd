extends Area2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
var life_span = 10.0

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	acceleration = (player.global_position - position).normalized() * 700
	life_span -= delta
	velocity += acceleration * delta
	rotation = velocity.angle()
	
	velocity = velocity.limit_length(150)
	position += velocity * delta
	if life_span <= 0: queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(0.5, global_position) 
		print(body.take_damage)
	queue_free()
