extends CharacterBody2D

@onready var logic_pos = get_parent().find_child("Logic")
@onready var player = get_tree().get_first_node_in_group("player")

@onready var sprite = $Golem

var direction : Vector2

func _ready():
	set_physics_process(false)	
	print(player.position)
#
func _process(_delta):
	pass
	

func _physics_process(delta):
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if not player:
			print("No player in group")
			return
	print(position)
	print("Following node:", player.name, " Class:", player.get_class(), " Position:", player.position)
	
	direction = player.position - position
	velocity = direction.normalized() * 40
	move_and_slide()
	
