extends State

func enter():
	super.enter()
	animation_player.play("Melee")

func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")


func _on_melee_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1, global_position) 
		print(body.take_damage)
