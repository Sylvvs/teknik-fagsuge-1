extends State

var can_transition : bool = false

func enter():
	super.enter()
	animation_player.play("Block")
	await animation_player.animation_finished
	can_transition = true

func block_away():
	pass

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("HomingMissile")


func _on_block_away_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(0, global_position) 
		print(body.take_damage)
