extends CharacterBody2D

@onready var logic_pos = get_parent().find_child("Logic")
@onready var player = null
@onready var sprite = $Golem
@onready var progress_bar = $UI/ProgressBar 
@onready var melee = $MeleeAttack
@onready var statemachine = $FiniteStateMachine
@onready var animation_player = $AnimationPlayer

var original_color : Color
var flash_time = 0.1
var flash_timer = 0.0
var direction : Vector2
var DEF = 0
var health = 2:
	
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 2.5
			find_child("FiniteStateMachine").change_state("ArmorBuff")
func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player = player.get_node("CharacterBody2D")
	if "Golem" in GameState.bosses_defeated and GameState.bosses_defeated["Golem"]:
		queue_free()
	set_physics_process(false)
	original_color = sprite.modulate
	
#
func _process(_delta):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	direction = player.global_position - position
	
	if flash_timer > 0:
		flash_timer -= _delta
		sprite.material.set_shader_parameter("flash_strength", 1.0)

	else:
		sprite.material.set_shader_parameter("flash_strength", 0.0)

func _physics_process(delta):
	if direction.x > 0:
		sprite.flip_h = false
		melee.scale.x = 1
	else :
		sprite.flip_h = true
		melee.scale.x = -1
	velocity = direction.normalized() * 80
	move_and_collide(velocity * delta)
	

func apply_damage(damage):
	flash_timer = flash_time
	health -= damage - DEF 



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1, global_position) 
		print(body.health)



	
