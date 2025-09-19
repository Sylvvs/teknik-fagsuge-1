extends LuciferState
@onready var lucifer = $"../.."
var dash_time_max = 0.1;
var dash_time = 0
var phase = 1;
var dir

func enter():
	super.enter()
	dash_time = 0
	phase = 1
	owner.set_physics_process(true)
	dash_time_max = 0.1;
	await play_animation("attack 2", 1)

func update_facing():
	if dir.x > 0:
		owner.aniplayrot.scale.x = 1
	elif dir.x < 0:
		owner.aniplayrot.scale.x = -1

func _physics_process(delta) -> void:
	owner.velocity.y += 500 * delta
	
	if dash_time < dash_time_max and phase == 1:
		owner.velocity.x += 150 * lucifer.aniplayrot.scale.x
		owner.velocity.y -= 200
		owner.move_and_slide()
	if dash_time > dash_time_max+1 and phase == 1: 
		dir = (player.global_position - global_position).normalized()
		animation_player.play()
		update_facing()
		dash_time = 0
		phase = 2
		dash_time_max = 0.3
	
	if dash_time < dash_time_max and phase == 2:
		owner.velocity = 1000 * dir
		owner.move_and_slide()
	
	if dash_time < dash_time_max and phase == 3:
		owner.velocity.x = 1000 * owner.aniplayrot.scale.x
		owner.move_and_slide()
	dash_time += delta

func pause_animation():
	animation_player.pause()

func last_slash():
	dir = (player.global_position - global_position).normalized()
	update_facing()
	phase = 3;
	dash_time = 0.0
	
	

func play_animation(anim_name: String, speed: float = 1.0,):
	animation_player.play(anim_name, -1.0, speed)
	await animation_player.animation_finished
	transition()
	if owner.direction.length() < 45:
		play_animation(anim_name, speed)


func transition():
	if animation_player.is_playing():
		return
	else:
		get_parent().change_state("LuciferFollow")
