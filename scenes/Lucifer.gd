extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
@onready var sprite : Sprite2D = $"Lucifer Animation Handler/Lucifer"
@onready var idk : Node2D = $"Lucifer Animation Handler"
@onready var aniplayrot : Marker2D = $"Lucifer Animation Handler/Animation virk pls"
@onready var collision : CollisionShape2D = $CollisionShape2D

var direction : Vector2

func _ready():
	set_physics_process(false)

func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		if not player:
			return
	direction = player.global_position - position
	
	if direction.x > 0:
		#sprite.flip_h = false
		#man kan også tage hele noden
		#aniplayrot.scale.x = 1
		#scale.x = 1
		scale.x = 1
	else:
		#sprite.flip_h = true
		#man kan også tage hele noden
		#aniplayrot.scale.x = -1
		#scale.x = -1
		scale.x = -1
		
func _physics_process(delta: float) -> void:
	pass
