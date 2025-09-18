extends LuciferState
@onready var lucifer = $"../.."
func enter():
	super.enter()
	set_physics_process(true)
	await play_animation("attack 1", 1)
	
func attack():
	lucifer.velocity.x += 35000 * lucifer.aniplayrot.scale.x
	lucifer.move_and_slide()
	print("hej")
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
