extends BatState
class_name BatDeath

func enter():
	enemy.velocity = Vector2.ZERO
	anim.play('Die')
	

func physics_update(delta: float):
	if anim.is_playing():
		return
	queue_free()
