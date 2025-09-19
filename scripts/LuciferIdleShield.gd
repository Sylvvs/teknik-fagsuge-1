extends LuciferState
@onready var idle_shield : Area2D = $"../../Idleshield"
func enter():
	super.enter()
	idle_shield.monitoring = true
	



func _on_idleshield_area_entered(area: Area2D) -> void:
	#if area.owner and area.owner.is_in_group("player"):
#		player.knockback_velocity = knockback_dir * player.SPEED * 10
	pass
func transition():
	pass
