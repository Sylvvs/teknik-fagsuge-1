extends EnemyState
func enter():
	super.enter()
	animation_player.play("Death")
	await animation_player.animation_finished
	queue_free()
