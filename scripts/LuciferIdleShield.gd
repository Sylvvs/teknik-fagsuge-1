extends LuciferState
var knockback_dir = (player.global_position - owner.global_position).normalized()

func enter():
	super.enter()
	



func _on_idleshield_area_entered(area: Area2D) -> void:
	if area.owner and area.owner.is_in_group("player"):
		player.knockback_velocity = knockback_dir * player.SPEED * 10
