extends CharacterBody2D
class_name BatEnemy

@onready var anim = $"Animation handler Bat/AnimationPlayer"
@onready var sprite = $"Animation handler Bat/Sprite2D"
@onready var hitbox = $"Attack Hitbox"
@onready var player : Node2D = null

var direction = Vector2.ZERO
var health = 20
var flash_time = 0.2
var flash_timer = 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player = player.get_node("CharacterBody2D")
		
	if sprite.material:
		sprite.material = sprite.material.duplicate()


func _process(delta: float) -> void:
	if flash_timer > 0:
		flash_timer -= delta
		sprite.material.set_shader_parameter("flash_strength", 1.0)

	else:
		sprite.material.set_shader_parameter("flash_strength", 0.0)
func _physics_process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	move_and_slide()
	direction = player.global_position - position
	if direction.x < 0:
		sprite.flip_h = false
		hitbox.scale.x = 1
	elif direction.x > 0:
		sprite.flip_h = true
		hitbox.scale.x = -1

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.take_damage(1, global_position)

func apply_damage(amount : float):
	flash_timer = flash_time
	health -= amount
