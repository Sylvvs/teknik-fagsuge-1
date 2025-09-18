extends LuciferState

func enter():
	super.enter()
	await play_animation("attack 1", 1)
	


func play_animation(anim_name: String, speed: float = 1.0):
	animation_player.play(anim_name, -1.0, speed)
	await animation_player.animation_finished
	if owner.direction.length() < 45:
		play_animation(anim_name, speed)


func transition():
	if owner.direction.length() > 45:
		get_parent().change_state("LuciferFollow")
