extends EnemyState

@onready var enemy = get_parent().get_parent() as CharacterBody2D
func enter():
	super.enter()
	animation_player.play("Death")
	await animation_player.animation_finished
	enemy.queue_free()
	
