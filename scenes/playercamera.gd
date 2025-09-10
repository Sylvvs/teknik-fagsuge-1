extends Camera2D

func _process(delta: float) -> void:
	global_position.x = get_parent().global_position.x - get_viewport_rect().size.x / 4
	position.y = -get_viewport_rect().size.y / 4
	
