extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;
var health = 100;

var is_knockback = false
var knockback_velocity = Vector2.ZERO  # Store knockback velocity
var knockback_duration = 0.6  # Duration of knockback effect
var knockback_timer = 0.0

var handler;


var SPRITE;
@onready var ap = $"Animation Handler/AnimationPlayer"
@onready var sprite = $"Animation Handler/Sprite2D"
@onready var sword = $"Animation Handler/Sprite2D/Sword Hitbox"
@onready var at : AnimationTree = $"AnimationTree"


func _ready():
	at.active = true
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	reset_combo()

func _process(delta: float) -> void:
	
	
	if is_knockback:
		knockback_timer -= delta
		if knockback_timer <= 0:
				is_knockback = false
				
	# Handle extended combo window
	if waiting_for_combo_input:
		combo_continue_timer += delta
		if combo_continue_timer >= combo_continue_window:
			print('too late')
			reset_combo()
			
	attack_failsafe -= delta
	if attack_failsafe <= 0:
		reset_combo()
		attack_failsafe = 5.0

func _physics_process(delta):
	if handler and handler.forcing_movement:
		return
	set_up_direction(Vector2.UP)
	if  is_knockback:
		velocity = knockback_velocity
		velocity.y += GRAV * delta
	elif Input.is_action_pressed("left"):
		if not is_attacking:
			sprite.flip_h = true
			sword.scale.x = -1
		velocity.x = -SPEED;
	elif Input.is_action_pressed("right"):
		if not is_attacking:
			sprite.flip_h = false
			sword.scale.x = 1
		velocity.x = SPEED;
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -JUMP;
		
	velocity.y = velocity.y + GRAV * delta;
	move_and_slide()
	update_animations(delta)


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	if area.owner:
		if area.owner.is_in_group('enemies'):
			var enemy: EnemySignal_Enemy = area.owner
			enemy.apply_damage(20)
	

var is_jumping = false

var is_attacking = false
var combo_step = 0
var combo_input_buffered = false
var can_combo = false
var attack_timer = 0.0
const COMBO_TIMEOUT = 200
var combo_continue_timer = 0.0
var combo_continue_window = 2  # 0.5 seconds after attack finishes
var waiting_for_combo_input = false
var attack_failsafe =  5

func update_animations(delta):
	# Movement conditions
	at["parameters/AnimationNodeStateMachine/conditions/idle"] = velocity == Vector2.ZERO and is_on_floor()
	at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = velocity.x != 0 and is_on_floor()
	# Attack
	#if Input.is_action_just_pressed("attack"):
	#	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
	#else:
	#	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	
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
	const falling_threshold = 10.0
	at["parameters/AnimationNodeStateMachine/conditions/falling"] = (
		velocity.y > falling_threshold and not is_on_floor()
		)
	
	#Combo Attack Input
	if Input.is_action_just_pressed("attack"):
		if combo_step == 0 and not is_attacking:
			#Start combo
			combo_step = 1
			attack_failsafe =  5
			is_attacking = true
			update_combo_conditions()
			at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
			at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = false
		elif can_combo:
			combo_input_buffered = true
		elif waiting_for_combo_input:
			combo_step += 1
			update_combo_conditions()
			is_attacking = true
			#can_combo = false
			waiting_for_combo_input = false
			attack_failsafe =  5
			combo_continue_timer = 0.0
			at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
			at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = false
		
	

func take_damage(amount):
	print(amount)
	reset_all_conditions()
	health -= amount
	is_knockback = true
	knockback_timer = knockback_duration
	knockback_velocity = Vector2.ZERO
	
	if velocity.x > 0 or velocity.x == 0:
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

func _on_attack_animation_finished():
	if combo_input_buffered:
		combo_step += 1
		update_combo_conditions()
		can_combo = false
		combo_input_buffered = false
		attack_timer = 0.0
		attack_failsafe =  5
	elif combo_step < 3:
		waiting_for_combo_input = true
		combo_continue_timer = 0.0
		attack_failsafe =  5
		can_combo = false
		is_attacking = false
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
		at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = true

	else:
		reset_combo()
	
func on_combo_window_open():
	can_combo = true
	
func reset_combo():
	combo_step = 0
	can_combo = false
	combo_input_buffered = false
	is_attacking = false
	waiting_for_combo_input = false  # <-- THIS LINE
	combo_continue_timer = 0.0 
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = true
	reset_all_conditions()
	
func update_combo_conditions():
	at["parameters/AnimationNodeStateMachine/Attack/conditions/is_attack1"] = combo_step == 1
	at["parameters/AnimationNodeStateMachine/Attack/conditions/is_attack2"] = combo_step == 2
	at["parameters/AnimationNodeStateMachine/Attack/conditions/is_attack3"] = combo_step == 3
	


func _on_sword_hitbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
			if body.is_in_group('enemies'):
				print('hit')
				body.apply_damage(20)
	pass # Replace with function body.
