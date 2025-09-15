extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;
var health = 100;
var is_knockback = false
var knockback_velocity = Vector2.ZERO  # Store knockback velocity
var knockback_duration = 0.6  # Duration of knockback effect
var knockback_timer = 0.0

var SPRITE;
@onready var ap = $"Animation Handler/AnimationPlayer"
@onready var sprite = $"Animation Handler/Sprite2D"
@onready var sword = $"Animation Handler/Sprite2D/Sword Hitbox"
@onready var at : AnimationTree = $"AnimationTree"


func _ready():
	at.active = true

func _process(delta: float) -> void:
	update_animations(delta)
	
	if is_knockback:
		knockback_timer -= delta
		if knockback_timer <= 0:
				is_knockback = false

	if Input.is_action_just_pressed("testing"):
		take_damage(1)


func _physics_process(delta):
	set_up_direction(Vector2.UP)
	if  is_knockback:
		velocity = knockback_velocity
		velocity.y += GRAV * delta
	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		sword.scale.x = -1
		velocity.x = -SPEED;
	elif Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		sword.scale.x = 1
		velocity.x = SPEED;
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -JUMP;
		
	velocity.y = velocity.y + GRAV * delta;
	move_and_slide()
	
	


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	var enemy: EnemySignal_Enemy = area.owner
	if enemy:
		enemy.apply_damage(20)
	

var is_jumping = false

func update_animations(delta):
	# Movement conditions
	at["parameters/AnimationNodeStateMachine/conditions/idle"] = velocity == Vector2.ZERO and is_on_floor()
	at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = velocity.x != 0 and is_on_floor()
	# Attack
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = Input.is_action_just_pressed("attack")
	# Jump input
	if Input.is_action_just_pressed("jump"):
		is_jumping = true
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = true
	elif velocity.y < 0 and is_jumping:
		# Still rising in jump
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = true
	else:
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = false
		is_jumping = false
	# Falling
	at["parameters/AnimationNodeStateMachine/conditions/falling"] = velocity.y > 0 and not is_on_floor()

func take_damage(amount):
	print(amount)
	reset_all_conditions()
	health -= amount
	is_knockback = true
	knockback_timer = knockback_duration
	knockback_velocity = Vector2.ZERO
	
	if velocity.x > 0:
		knockback_velocity.x = -SPEED * 0.5
		knockback_velocity.y = -50
	elif velocity.x < 0:
		knockback_velocity.x = SPEED * 0.5
		knockback_velocity.y = -50
	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = true
	await get_tree().create_timer(0.6).timeout
	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = false


var condition_keys = [
	"idle",
	"is_moving",
	"attacking",
	"jump",
	"falling",
	"hurting",
	# Add all your conditions here
]
func reset_all_conditions():
	var base_path = "parameters/AnimationNodeStateMachine/conditions/"
	for key in condition_keys:
		at[base_path + key] = false
