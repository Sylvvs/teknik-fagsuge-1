extends BatState
class_name BatWakeUp


func enter():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player = player.get_node("CharacterBody2D")
	enemy.velocity = Vector2.ZERO
	anim.play('WakeUp')
	

func physics_update(delta: float):
	if anim.is_playing():
		return
	Transitioned.emit(self,'BatChase')
	if enemy.health <= 0:
		Transitioned.emit(self,'BatDeath')
