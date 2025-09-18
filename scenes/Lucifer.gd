extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
@onready var logic_pos = get_parent().find_child("Logic")
@onready var sprite : Sprite2D = $"Lucifer Animation Handler/Lucifer"
@onready var idk : Node2D = $"Lucifer Animation Handler"
@onready var aniplayrot : Marker2D = $"Lucifer Animation Handler/Animation virk pls"
@onready var debug_tag : Label = $debug
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
var direction : Vector2
var SPEED : float = 80
var GRAVITY : float = 500.0

func _ready():
	set_physics_process(false)

func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	
	# Calculate horizontal direction towards player
	# Direction towards player
	
	direction = player.global_position - position
	#print(player.global_position, position, direction)
	# Flip sprite depending on x-direction

	if direction.x > 0:
		aniplayrot.scale.x = 1
		collision_shape.position.x = abs(collision_shape.position.x)
	elif direction.x < 0:
		aniplayrot.scale.x = -1
		collision_shape.position.x -= collision_shape.position.x

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0  # Lucifer stays on ground, no jumping
	
	# Move only horizontally towards player
	var move_dir = direction.normalized()

	
	velocity.x = move_dir.x * SPEED

	
	# Apply movement with collisions
	move_and_slide()

func _on_attack_1_and_attack_2_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.take_damage(1, global_position)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1, global_position)
