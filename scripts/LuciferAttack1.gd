extends LuciferState
@onready var lucifer = $"../.."
var dash_time_max = 0.075;
var dash_time = dash_time_max

func enter():
	super.enter()
	set_physics_process(true)
	await play_animation("attack 1", 1)
	
func attack():
	dash_time = 0

func _process(delta: float) -> void:
	if dash_time < dash_time_max:
		lucifer.velocity.x += 300 * lucifer.aniplayrot.scale.x
		lucifer.move_and_slide()
	dash_time += delta

func play_animation(anim_name: String, speed: float = 1.0,):
	animation_player.play(anim_name, -1.0, speed)
	await animation_player.animation_finished
	if owner.direction.length() < 45:
		play_animation(anim_name, speed)


func transition():
	if animation_player.is_playing():
		return
	else:
		if owner.direction.length() > 45:
			get_parent().change_state("LuciferFollow")
