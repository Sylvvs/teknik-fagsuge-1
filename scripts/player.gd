extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;
var health = 100;

var is_knockback = false
var knockback_velocity = Vector2.ZERO  # Store knockback velocity
var knockback_duration = 0.15  # Duration of knockback effect
var knockback_timer = 0.0

var attack_cooldown = false
var attack_timer = 0.0
var attack_cooldown_duration = 0.25

var handler;


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
	if attack_cooldown:
		attack_timer -= delta
		if attack_timer <= 0:
			attack_cooldown = false


func _physics_process(delta):
	if handler and handler.forcing_movement:
		return
	set_up_direction(Vector2.UP)
	if  is_knockback:
		velocity = knockback_velocity
		velocity.y += GRAV * delta
	elif Input.is_action_pressed("ui_left"):
		if not is_attacking:
			sprite.flip_h = true
			sword.scale.x = -1
		velocity.x = -SPEED;
	elif Input.is_action_pressed("ui_right"):
		if not is_attacking:
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
	if area.owner.is_in_group('enemies'):
		var enemy: EnemySignal_Enemy = area.owner
		enemy.apply_damage(20)
	

var is_jumping = false
var is_attacking = false
func update_animations(delta):
	# Movement conditions
	at["parameters/AnimationNodeStateMachine/conditions/idle"] = velocity == Vector2.ZERO and is_on_floor()
	at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = velocity.x != 0 and is_on_floor()
	# Attack
	if Input.is_action_just_pressed("attack") and attack_cooldown == false:
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
		attack_cooldown = true
		is_attacking = true
		attack_timer = attack_cooldown_duration
	else:
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	
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
	
	if velocity.x > 0 or velocity.x == 0:
		knockback_velocity.x = -SPEED
		knockback_velocity.y = -50
	elif velocity.x < 0:
		knockback_velocity.x = SPEED
		knockback_velocity.y = -50
	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = true
	await get_tree().create_timer(0.15).timeout
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

func _on_attack_animation_finished():
	is_attacking = false
