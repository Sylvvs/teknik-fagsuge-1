extends EnemyState

var can_transition: bool = false

func enter():
	super.enter()
	animation_player.play("Hurt")
	await animation_player.animation_finished
	can_transition = true

func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("EnemyAttack")
