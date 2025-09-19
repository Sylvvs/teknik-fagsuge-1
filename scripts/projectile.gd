extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
var life_span = 5.0

var velocity: Vector2 = Vector2.ZERO
var dir;

func _ready() -> void:
	animation_player.play("idle")
	monitoring = false;
	visible = false;
	dir = (player.global_position - global_position).normalized()

func set_target():
	if player:
		global_position.y += -25.0
		var angle = dir.angle() - deg_to_rad(26)
		rotation = angle
		position += dir * 60
		velocity = dir * 1000

func _physics_process(delta: float) -> void:
	if life_span < 4.85 and not monitoring:
		monitoring = true;
		visible = true;
		set_target()
		life_span = 5.0
	life_span -= delta
	if life_span <= 0: queue_free()
	
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1, global_position) 
	# queue_free()
