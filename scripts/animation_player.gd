extends AnimationPlayer



func _process(_delta: float) -> void:
	if Input.is_action_pressed("interact"):
		skip_animation()

func skip_animation() -> void:
	if is_playing():
		stop()  
		emit_signal("animation_finished", "rah")
