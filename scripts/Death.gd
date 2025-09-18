extends State

func enter():
	super.enter()
	animation_player.play("Death")
	GameState.bosses_defeated["Golem"] = true;
	await animation_player.animation_finished
	animation_player.play("boss_slain")
