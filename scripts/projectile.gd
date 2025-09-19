extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
var life_span = 5.0

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_player.play("idle")
	set_target()

func set_target():
	if player:
		global_position.y += -25.0
		var dir = (player.global_position - global_position).normalized()
		var angle = dir.angle() - deg_to_rad(26)
		rotation = angle
		position += dir * 60
		velocity = dir * 500

func _physics_process(delta: float) -> void:
	life_span += delta
	if life_span <= 0: queue_free()
	
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1, global_position) 
	# queue_free()
