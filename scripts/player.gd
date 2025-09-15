extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;

var SPRITE;
@onready var ap = $"Animation Handler/AnimationPlayer"
@onready var sprite = $"Animation Handler/Sprite2D"
@onready var sword = $"Animation Handler/Sprite2D/Sword Hitbox"
@onready var at : AnimationTree = $"AnimationTree"


func _ready():
	at.active = true

func _process(delta: float) -> void:
	update_animations()


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
	
	pass 

func update_animations():
	if velocity == Vector2.ZERO:
		at["parameters/AnimationNodeStateMachine/conditions/idle"] = true
		at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = false
	else:
		at["parameters/AnimationNodeStateMachine/conditions/idle"] = false
		at["parameters/AnimationNodeStateMachine/conditions/is_moving"] = true
	if Input.is_action_just_pressed("attack"):
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = true
	else:
		at["parameters/AnimationNodeStateMachine/conditions/attacking"] = false
