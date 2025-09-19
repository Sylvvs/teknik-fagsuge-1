extends State

@onready var audio = $AudioStreamPlayer

func enter():
	super.enter()
	animation_player.play("Death")
	audio.play()
	GameState.bosses_defeated["Golem"] = true;
	GameState.boss_defeated_trigger()
	GameState.orb_obtained = true;
	var ui = get_tree().root.get_node("Ui/ItemPopUp")
	ui.display()
	await animation_player.animation_finished
	animation_player.play("boss_slain")
