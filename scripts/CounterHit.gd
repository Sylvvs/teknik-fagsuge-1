extends LuciferState

@onready var sprite = $"../../Lucifer Animation Handler/Animation virk pls/Lucifer"
@onready var counter_area: Area2D = $"../../Counter"

var player_hit := false
var is_countering := false
var flashing = false;
var flash_timer = 0.0;
var flash = false;


func start_counter():
	is_countering = true
	player_hit = false
	flashing = true;
	
	counter_area.monitoring = true
	await get_tree().create_timer(2).timeout
	flashing = false;
	if not player_hit:
		end_counter()

func _physics_process(delta):
	if flashing:
		flash_timer += delta
		if flash_timer > 0.1:
			flash_timer = 0.0;
			flash = !flash
		if flash:
			sprite.material.set_shader_parameter("flash_strength", 0.0)
		else:
			sprite.material.set_shader_parameter("flash_strength", 1.0)

func end_counter():
	is_countering = false
	counter_area.monitoring = false
	#transition()
	get_parent().call_deferred("change_state", "LuciferFollow")
	
func enter():
	super.enter()
	player_hit = false
	is_countering = false
	start_counter()
	owner.set_physics_process(true)

func exit():
	super.exit()
	counter_area.monitoring = false
	sprite.material.set_shader_parameter("flash_strength", 0.0)
	owner.set_physics_process(false)

func transition():
	if player_hit:
		#get_parent().call_deferred("change_state", "Counter2")
		player_hit = false
	else:
		pass
		#get_parent().call_deferred("change_state", "LuciferFollow")


func _on_counter_area_entered(area: Area2D) -> void:
	if area.owner and area.owner.is_in_group("player"):
		player_hit = true
		print("hit")
		#transition()
		flashing = false
		get_parent().call_deferred("change_state", "Counter2")
