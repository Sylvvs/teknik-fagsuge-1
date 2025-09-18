extends CharacterBody2D

@onready var sprite : Sprite2D = $"Animation Handler Enemy/Sprite2D"
@onready var animation_player : AnimationPlayer = $"Animation Handler Enemy/AnimationPlayer"
@onready var logic_pos = get_parent().find_child("Logic")
@onready var player : Node2D = null
@onready var enemysword : Area2D = $Attack

var direction : Vector2
var flee_mode: bool = true  
var switch_timer := 0.0
const SPEED := 80
const GRAVITY := 600.0
const JUMP_FORCE := -300.0
var health = 50
var flash_time = 0.2
var flash_timer = 0.0



func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player = player.get_node("CharacterBody2D")
	set_physics_process(false)
	
	if sprite.material:
		sprite.material = sprite.material.duplicate()

func apply_damage(amount : float):
	var take_damage : bool = false
	health -= amount
	take_damage = true
	if take_damage:
		flash_timer = flash_time
		#find_child("EnemyFiniteStateMachine").change_state("EnemyHurt")
	if health <= 0:
		find_child("EnemyFiniteStateMachine").change_state("EnemyDeath")
	
	await get_tree().create_timer(0.2).timeout

func _process(delta):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return

	direction = player.global_position - position
	
	switch_timer -= delta
	if switch_timer <= 0:
		flee_mode = randf() < 0.65
		switch_timer = randf_range(1.0, 1.5)
	if flash_timer > 0:
		flash_timer -= delta
		sprite.material.set_shader_parameter("flash_strength", 1.0)

	else:
		sprite.material.set_shader_parameter("flash_strength", 0.0)
		
	if direction.x > 0:
		sprite.flip_h = false
		enemysword.scale.x = 1
	else:
		sprite.flip_h = true
		enemysword.scale.x = -1
func _physics_process(delta):
	
	# Gravity
	velocity.y += GRAVITY * delta

	# Movement logic
	var move_dir : Vector2
	if flee_mode:
		move_dir = -direction.normalized()
		
		# Random jump chance while fleeing
		if is_on_floor() and randf() < 0.01:
			velocity.y = JUMP_FORCE
	else:
		move_dir = direction.normalized()
	# Flip sprite
	

	# Apply horizontal movement
	velocity.x = move_dir.x * SPEED

	# Use built-in sliding physics
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.take_damage(1, global_position)
