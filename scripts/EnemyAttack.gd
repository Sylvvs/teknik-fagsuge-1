extends EnemyState

func enter():
	super.enter()
	animation_player.play("Attack")

func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("EnemyRun")
