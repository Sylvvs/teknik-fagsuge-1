extends CharacterBody2D

@onready var logic_pos = get_parent().find_child("Logic")
@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
@onready var sprite = $Golem
@onready var progress_bar = $UI/ProgressBar 
var direction : Vector2
var DEF = 0
var health = 1000:
	
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
		elif value <= progress_bar.max_value / 2 and DEF == 0:
			DEF = 5
			find_child("FiniteStateMachine").change_state("ArmorBuff")
func _ready():
	set_physics_process(false)
	
#
func _process(_delta):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	direction = player.global_position - position

func _physics_process(delta):
	if direction.x > 0:
		sprite.flip_h = false
	else :
		sprite.flip_h = true
	velocity = direction.normalized() * 80
	move_and_collide(velocity * delta)
	

func apply_damage(damage):
	print("hej")
	health -= damage - DEF 



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(5, global_position) 
		print(body.take_damage)
		




	
