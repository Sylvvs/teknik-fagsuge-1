extends LuciferState

var dash_time_max = 0.5;
var dash_time = dash_time_max

func enter():
	super.enter()
	counter_move()
	owner.set_physics_process(false)

func exit():
	super.exit()
	owner.set_physics_process(true)

func counter_move():
	if not player: 
		return
	var dir = sign(player.global_position.x - owner.global_position.x)
	
	# Diagonal offset: right-up or left-up
	var offset = Vector2(-50 * dir, -100) 
	# Teleport Lucifer
	owner.global_position += offset
	play_animation("attack 1", 1) 
func play_animation(anim_name: String, speed: float = 1.0):
	animation_player.play(anim_name, -1.0, speed)
	await animation_player.animation_finished
	#play_animation(anim_name, speed)

func transition():
	if animation_player.is_playing():
		return
	else:
		get_parent().call_deferred("change_state", "LuciferFollow")

func attack():
	if not get_parent().current_state.name == "Counter2":
		return
	dash_time = 0.0;
	dir_dash = sign(player.global_position.x - owner.global_position.x)

var dir_dash
func _process(delta: float) -> void:
	dash_time += delta
	if dash_time < dash_time_max:
		owner.velocity += Vector2(dir_dash*300, 100) 
		owner.move_and_slide()
