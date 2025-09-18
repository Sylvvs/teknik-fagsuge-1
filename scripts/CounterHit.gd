extends LuciferState

@onready var sprite = $"../../Lucifer Animation Handler/Animation virk pls/Lucifer"
@onready var counter_area: Area2D = $"../../Counter"

var player_hit := false
var is_countering := false


func start_counter():
	is_countering = true
	player_hit = false
	
	sprite.material.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(2).timeout 
	sprite.material.set_shader_parameter("flash_strength", 0.0)
	counter_area.monitoring = true

	await get_tree().create_timer(2).timeout
	if not player_hit:
		end_counter()

func end_counter():
	is_countering = false
	counter_area.monitoring = false
	transition()
	
func enter():
	super.enter()
	player_hit = false
	is_countering = false
	await start_counter()

func exit():
	super.exit()
	counter_area.monitoring = false
	sprite.material.set_shader_parameter("flash_strength", 0.0)

func transition():
	if player_hit:
		get_parent().change_state("Counter2")
	else:
		get_parent().change_state("LuciferFollow")

func _on_counter_area_entered(area: Area2D) -> void:
	if area.owner and area.owner.is_in_group("player"):
		player_hit = true
		if player_hit:
			print("hit")
			transition()
