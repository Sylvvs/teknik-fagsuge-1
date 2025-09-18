extends State
@onready var audio = $AudioStreamPlayer
func enter():
	super.enter()
	animation_player.play("Death")
	audio.play()
	await animation_player.animation_finished
	animation_player.play("boss_slain")
