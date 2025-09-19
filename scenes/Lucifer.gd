extends CharacterBody2D

@onready var player = null
@onready var logic_pos = get_parent().find_child("Logic")
@onready var sprite : Sprite2D = $"Lucifer Animation Handler/Lucifer"
@onready var idk : Node2D = $"Lucifer Animation Handler"
@onready var aniplayrot : Marker2D = $"Lucifer Animation Handler/Animation virk pls"
@onready var debug_tag : Label = $debug
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var progress_bar = $UI/ProgressBar
var direction : Vector2
var SPEED : float = 80
var GRAVITY : float = 500.0
var health = 500


func apply_damage(amount : float):
	if get_node("LuciferFiniteStateMachine").current_state.name == "CounterHit":
		return
	health -= amount
	progress_bar.value = health
	if health <= 0:
		progress_bar.visible = false
		find_child("LuciferFiniteStateMachine").change_state("LuciferDeath")
		print(health)

func _ready():
	set_physics_process(false)

func _process(_delta: float) -> void:
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	
	# Calculate horizontal direction towards player
	# Direction towards player
	
	direction = player.global_position - position
	#print(player.global_position, position, direction)
	# Flip sprite depending on x-direction


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0  # Lucifer stays on ground, no jumping
	
	# Move only horizontally towards player
	var move_dir = direction.normalized()

	if direction.x > 0:
		aniplayrot.scale.x = 1
	elif direction.x < 0:
		aniplayrot.scale.x = -1
	velocity.x = move_dir.x * SPEED
	# Apply movement with collisions
	move_and_slide()

func _on_attack_1_and_attack_2_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.take_damage(1, global_position)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1, global_position)
