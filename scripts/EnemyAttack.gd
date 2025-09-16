extends EnemyState

var can_transition: bool = false

func enter():
	super.enter()
	await play_animation("Attack", 3)
	can_transition = true

func play_animation(anim_name: String, speed: float = 1.0):
	animation_player.play(anim_name, -1.0, speed) 
	await animation_player.animation_finished

func transition():
	if can_transition:
		can_transition = false
		if owner.direction.length() >= 45:
			get_parent().change_state("EnemyRun")
