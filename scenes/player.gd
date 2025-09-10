extends CharacterBody2D

var SPEED = 200;
const JUMP = 400;
const GRAV = 800;

var SPRITE;
@onready var ap = $"Animation Handler/AnimationPlayer"
@onready var sprite = $"Animation Handler/Sprite2D"

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
	
	if abs(velocity.x) > 0:
		if velocity.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		ap.speed_scale = 2.7
		ap.play('walk')
	if velocity.x == 0 and velocity.y == 0:
		ap.speed_scale = 1
		ap.play('idle')


func _on_sword_hitbox_area_entered(area: Area2D) -> void:
	
	pass 
