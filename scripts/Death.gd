extends State
@onready var audio = $AudioStreamPlayer
func enter():
	super.enter()
	animation_player.play("Death")
	audio.play()
	GameState.bosses_defeated["Golem"] = true;
	await animation_player.animation_finished
	animation_player.play("boss_slain")
