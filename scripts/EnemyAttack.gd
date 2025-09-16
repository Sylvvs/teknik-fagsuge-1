extends EnemyState

var can_transition: bool = false
func enter():
	super.enter()
	await play_animation("Attack")
	can_transition = true
func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished
	
func transition():
	if can_transition:
		can_transition = false
		if owner.direction.length() > 30:
			get_parent().change_state("EnemyRun")
