extends LuciferState

func enter():
	super.enter()
	counter_move()


func counter_move():
	if not player: 
		return
	
	var dir = sign(player.global_position.x - owner.global_position.x)
	
	# Diagonal offset: right-up or left-up
	var offset = Vector2(10 * dir, -100) 
	
	# Teleport Lucifer
	owner.global_position += offset
	
	
	await play_animation("attack 1", 1) 
func play_animation(anim_name: String, speed: float = 1.0):
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
