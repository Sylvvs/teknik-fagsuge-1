extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;

var SPRITE;

func _ready():
	pass

func _physics_process(delta):
	set_up_direction(Vector2.UP)
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED;
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED;
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -JUMP;
		velocity.x = SPEED;
		
	velocity.y = velocity.y + GRAV * delta;
	move_and_slide()
