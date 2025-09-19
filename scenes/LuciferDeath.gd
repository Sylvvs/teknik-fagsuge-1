extends LuciferState
@onready var lucifer = get_parent().get_parent() as CharacterBody2D
func enter():
	super.enter()
	animation_player.play("Death")
	await animation_player.animation_finished
	animation_player.play("boss_killed")
	print("hej")
	if animation_player.is_playing():
		return
	else:
		lucifer.queue_free()
