extends CharacterBody2D

@onready var at : AnimationTree = $"AnimationTree"
@onready var sprite : Sprite2D = $"Animation Handler Enemy/Sprite2D"
@onready var logic_pos = get_parent().find_child("Logic")
@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")

var direction : Vector2
var flee_mode: bool = true  
var switch_timer := 0.0

const SPEED := 240
const GRAVITY := 600.0
const JUMP_FORCE := -300.0

var health: int = 100:
	set(value):
		health = value
		if health <= 0:
			queue_free()

func _ready():
	set_physics_process(false)
	at.active = true

func apply_damage(amount : int):
	health -= amount
	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = true
	await get_tree().create_timer(0.2).timeout
	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = false

func update_animations():
	if Vector2.ZERO:
		at["parameters/AnimationNodeStateMachine/conditions/idle"] = true
	else:
		pass

func _process(delta):
	update_animations()
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return

	direction = player.global_position - position

	switch_timer -= delta
	if switch_timer <= 0:
		flee_mode = randf() < 0.65
		switch_timer = randf_range(1.0, 1.5)

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	var move_dir : Vector2
	if flee_mode:
		move_dir = -direction.normalized()
		
		if is_on_floor() and randf() < 0.01:
			velocity.y = JUMP_FORCE
	else:
		move_dir = direction.normalized()

	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	velocity.x = move_dir.x * SPEED
	move_and_slide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.take_damage(10, global_position)
