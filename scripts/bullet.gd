extends Area2D


@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	acceleration = (player.global_position - position).normalized() * 700
	
	velocity += acceleration * delta
	rotation = velocity.angle()
	
	velocity = velocity.limit_length(150)
	position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
