extends CharacterBody2D

@onready var logic_pos = get_parent().find_child("Logic")
@onready var player = get_tree().get_first_node_in_group("player")

@onready var sprite = $Golem

var direction : Vector2


func _ready():
	set_physics_process(false)
	
#
func _process(_delta):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if not player:
			return
	direction = player.global_position - position

func _physics_process(delta):
	if direction.x > 0:
		sprite.flip_h = false
	else :
		sprite.flip_h = true
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
	
