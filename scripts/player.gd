extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;
var health = 100;

var SPRITE;
@onready var ap = $"Animation Handler/AnimationPlayer"
@onready var sprite = $"Animation Handler/Sprite2D"
@onready var sword = $"Animation Handler/Sprite2D/Sword Hitbox"
@onready var at : AnimationTree = $"AnimationTree"


func _ready():
	at.active = true

func _process(delta: float) -> void:
	update_animations(delta)


func _physics_process(delta):
	set_up_direction(Vector2.UP)
	if Input.is_action_pressed("ui_left"):
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
var is_hitstunned = false
var hitstun_time = 0.5  # duration of hitstun in seconds
var hitstun_timer = 0.0

func update_animations(delta):
	
	if is_hitstunned:
		hitstun_timer -= delta
		at["parameters/AnimationNodeStateMachine/conditions/hurting"] = true
		
		at["parameters/AnimationNodeStateMachine/conditions/idle"] = false
		at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = false
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
		at["parameters/AnimationNodeStateMachine/conditions/falling"] = false
		at["parameters/AnimationNodeStateMachine/conditions/jump"] = false
		
		if hitstun_timer <= 0:
			is_hitstunned = false
			at["parameters/AnimationNodeStateMachine/conditions/hurting"] = false
			return
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
	health -= amount
	is_hitstunned= true
	hitstun_timer = hitstun_time
