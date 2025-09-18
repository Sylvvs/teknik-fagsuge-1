extends EnemyState


func enter():
	super.enter()
	owner.set_process(false)
	owner.set_physics_process(false)
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free()
	
