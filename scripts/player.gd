extends CharacterBody2D

# === Constants ===
const SPEED = 200
const JUMP = 400
const GRAV = 800
const COMBO_TIMEOUT = 200
const COMBO_CONTINUE_WINDOW = 1
const ATTACK_FAILSAFE_TIME = 1.1
const STATE_FAILSAFE = 0.1
const IMMUNITY_TIME = 0.5


# === State Variables ===
var damage = 5
var max_health = 10
var health = max_health
var is_special_attacking = false
var is_healing = false
var is_jumping = false
var is_parrying = false
var is_attacking = false
var is_knockback = false
var is_dashing = false
var waiting_for_combo_input = false
var is_air_attacking = false

# === Movement / Effects ===
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.15
var knockback_timer = 0.0
var dashing_velocity = Vector2.ZERO
var state_timer = 0.0
var immunity_timer = 0.0

# === Combo System ===
var combo_step = 0
var combo_input_buffered = false
var can_combo = false
var attack_timer = 0.0
var combo_continue_timer = 0.0
var attack_failsafe = ATTACK_FAILSAFE_TIME

# === Calm System ===
var calm_energy = 10
var max_calm_energy = 10
var calm_energy_heal_requirement = 7
var calm_energy_special_requirement = 5

signal health_changed(current: int)
signal calm_changed(current: int)

# === Animation Nodes ===
@onready var ap = $"Animation Handler/AnimationPlayer"
@onready var sprite = $"Animation Handler/Sprite2D"
@onready var sword = $"Animation Handler/Sprite2D/Sword Hitbox"
@onready var at : AnimationTree = $"AnimationTree"

# === Other ===
var handler
var condition_keys = [
	"idle",
	"is_moving",
	"attacking",
	"jump",
	"falling",
	"hurting",
	"dashing",
	"healing",
]

# === Ready ===
func _ready():
	at.active = true
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	reset_combo()

# === Process ===
func _process(delta: float) -> void:
	if is_knockback:
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knockback = false

	if waiting_for_combo_input:
		combo_continue_timer += delta
		if combo_continue_timer >= COMBO_CONTINUE_WINDOW:
			reset_combo()

	attack_failsafe -= delta
	if attack_failsafe <= 0:
		reset_combo()
		attack_failsafe = ATTACK_FAILSAFE_TIME
	if check_conditions() == false:
		state_timer += delta
	elif check_conditions() == true:
		state_timer = 0.0
	if state_timer >= STATE_FAILSAFE:
		at["parameters/AnimationNodeStateMachine/conditions/idle"] = true
		reset_combo()
		is_special_attacking = false
		state_timer = 0.0
	
	immunity_timer += delta

# === Physics Process ===
func _physics_process(delta: float) -> void:
	if handler and handler.forcing_movement:
		return
	if is_healing or is_special_attacking or is_parrying:
		return
	
	set_up_direction(Vector2.UP)

	
	#Die
	if health <= 0:
		get_tree().quit()
	# Knockback logic
	if is_knockback:
		velocity = knockback_velocity
		velocity.y += GRAV * delta
		move_and_slide()
		return

	# Dash logic
	elif is_dashing:
		velocity.x = dashing_velocity
		velocity.y += GRAV * delta

	# Movement input
	elif Input.is_action_pressed("left"):
		sprite.flip_h = true
		sword.scale.x = -1
		velocity.x = -SPEED

	elif Input.is_action_pressed("right"):
		sprite.flip_h = false
		sword.scale.x = 1
		velocity.x = SPEED

	else:
		velocity.x = 0

	# Jumping
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -JUMP

	# Dash input
	if Input.is_action_just_pressed("dash"):
		dashing_velocity = (
			sign(velocity.x) if velocity.x != 0
			else (-1 if sprite.flip_h else 1)
		) * SPEED * 3
		is_dashing = true
	if Input.is_action_just_pressed('heal'):
		heal_player()
	if Input.is_action_just_pressed('special attack'):
		special_attack()
	#if Input.is_action_just_pressed('parry'):
	#	parry()
	# Apply gravity
	velocity.y += GRAV * delta
	move_and_slide()

	if is_on_floor():
		is_air_attacking = false
		at["parameters/AnimationNodeStateMachine/Attack/conditions/air_attack"] = false
		
	update_animations(delta)

# === Animations ===
func update_animations(_delta: float) -> void:
	# Basic movement
	at["parameters/AnimationNodeStateMachine/conditions/idle"] = velocity == Vector2.ZERO and is_on_floor()
	at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = velocity.x != 0 and is_on_floor()

	# Jumping
	if Input.is_action_just_pressed("jump"):
		is_jumping = true
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = true
	elif velocity.y < 0 and is_jumping:
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = true
	else:
		is_jumping = false
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = false
	
	#Sliding
	#at[""]
	
	# Falling
	at["parameters/AnimationNodeStateMachine/conditions/falling"] = velocity.y > 10.0 and not is_on_floor()

	# Attacking
	if Input.is_action_just_pressed("attack"):
		if not is_on_floor():
			if not is_air_attacking:
				start_air_attack()
	  				  # Only air attack if not currently attacking in ai
		else:
			   # Only run ground combo logic if on floor
			if combo_step == 0 and not is_attacking:
				start_combo()
			elif can_combo:
				combo_input_buffered = true
			elif waiting_for_combo_input:
				continue_combo()


	# Dashing animation
	at["parameters/AnimationNodeStateMachine/conditions/dashing"] = Input.is_action_just_pressed("dash")

func start_air_attack():
	if is_on_floor():
		return  # only air attack when NOT on floor
	
	is_air_attacking = true
	is_attacking = true  # so that other attacks can't start
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
	at["parameters/AnimationNodeStateMachine/Attack/conditions/air_attack"] = true
	

	
func start_combo():
	combo_step = 1
	is_attacking = true
	attack_failsafe = ATTACK_FAILSAFE_TIME
	update_combo_conditions()
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
	at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = false

func continue_combo():
	combo_step += 1
	update_combo_conditions()
	is_attacking = true
	waiting_for_combo_input = false
	can_combo = false
	combo_continue_timer = 0.0
	attack_failsafe = ATTACK_FAILSAFE_TIME
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
	at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = false

# === Attack Animation Events ===
func _on_attack_animation_finished():
	if combo_input_buffered:
		combo_step += 1
		update_combo_conditions()
		combo_input_buffered = false
		can_combo = false
		attack_timer = 0.0
		attack_failsafe = ATTACK_FAILSAFE_TIME

	elif combo_step < 3:
		waiting_for_combo_input = true
		combo_continue_timer = 0.0
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
	waiting_for_combo_input = false
	combo_continue_timer = 0.0
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = true
	update_combo_conditions()
	reset_all_conditions()

func update_combo_conditions():
	at["parameters/AnimationNodeStateMachine/Attack/conditions/is_attack1"] = combo_step == 1
	at["parameters/AnimationNodeStateMachine/Attack/conditions/is_attack2"] = combo_step == 2
	at["parameters/AnimationNodeStateMachine/Attack/conditions/is_attack3"] = combo_step == 3

# === Dash Animation Event ===
func _on_dash_animation_end():
	is_dashing = false

# === Damage & Knockback ===
func take_damage(amount: int, from_position: Vector2) -> void:
	if immunity_timer < IMMUNITY_TIME:
		return
	else:
		immunity_timer = 0.0
	if is_healing:
		at["parameters/AnimationNodeStateMachine/conditions/healing"] = false
		is_healing = false
	if is_parrying:
		return
	_on_special_attack_done()
	reset_all_conditions()
	health -= amount
	emit_signal("health_changed", health)
	is_knockback = true
	knockback_timer = knockback_duration
	
	var knockback_dir = (global_position - from_position).normalized()
	knockback_velocity = knockback_dir * SPEED * 5
	knockback_velocity.y = -100

	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = true
	await get_tree().create_timer(0.15).timeout
	at["parameters/AnimationNodeStateMachine/conditions/hurting"] = false

# === Reset Anim Conditions ===
func reset_all_conditions():
	var base_path = "parameters/AnimationNodeStateMachine/conditions/"
	for key in condition_keys:
		at[base_path + key] = false

# === Sword Hit Detection ===
func _on_sword_hitbox_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.is_in_group("enemies"):
		if calm_energy < max_calm_energy:
			calm_energy += 1
			emit_signal("calm_changed", calm_energy)
		body.apply_damage(damage)
func _on_air_attack_animation_finished():
	is_air_attacking = false
	is_attacking = false
	at["parameters/AnimationNodeStateMachine/Attack/conditions/air_attack"] = false
	at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = true
	reset_combo()

func heal_player():
	if calm_energy >= calm_energy_heal_requirement:
		calm_energy -= calm_energy_heal_requirement
		emit_signal("calm_changed", calm_energy)
		is_healing = true
		at["parameters/AnimationNodeStateMachine/conditions/healing"] = true
		
	else:
		return
func _on_heal_done():
	is_healing = false
	at["parameters/AnimationNodeStateMachine/conditions/healing"] = false
	health += 5
	emit_signal("health_changed", health)
	if health > max_health:
		health = max_health
func _set_damage(move_damage):
	damage = move_damage
func special_attack():
	if calm_energy >= calm_energy_special_requirement and is_on_floor():
		calm_energy -= calm_energy_special_requirement
		emit_signal("calm_changed", calm_energy)
		reset_combo()
		is_attacking = true
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
		at["parameters/AnimationNodeStateMachine/Attack/conditions/special_attack"] = true
		is_special_attacking = true
	
func _on_special_attack_done():
	is_special_attacking = false
	at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
	at["parameters/AnimationNodeStateMachine/Attack/conditions/special_attack"] = false
	at["parameters/AnimationNodeStateMachine/Attack/conditions/not_attacking"] = true
func check_conditions():
	var base_path = "parameters/AnimationNodeStateMachine/conditions/"
	for key in condition_keys:
		if at[base_path + key] == false:
			pass
		else:
			return true
	return false


func _on_parry_hitbox_area_entered(area: Area2D) -> void:
	if area.owner:
		if area.owner.is_in_group('enemies'):
			at["parameters/AnimationNodeStateMachine/Parry/conditions/parry_hit"] = true
			area.owner.apply_damage(0)
		
	pass # Replace with function body.
func parry():
	reset_all_conditions()
	is_parrying = true
	at["parameters/AnimationNodeStateMachine/conditions/parry"] = true
	
func _on_parry_timeout():
	is_parrying = false
	velocity.y = 0
	at["parameters/AnimationNodeStateMachine/conditions/parry"] = false
	at["parameters/AnimationNodeStateMachine/Parry/conditions/parry_timeout"] = true
func _on_parry_end():
	is_parrying = false
	at["parameters/AnimationNodeStateMachine/conditions/parry"] = false
	at["parameters/AnimationNodeStateMachine/Parry/conditions/parry_hit"] = false
	at["parameters/AnimationNodeStateMachine/Parry/conditions/parry_timeout"] = true
	at["parameters/AnimationNodeStateMachine/conditions/idle"] = true


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	print('cool')
	if area.is_in_group('bullets'):
		area.queue_free()
