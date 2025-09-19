extends Control

@onready var panel = $MarginContainer/Panel

var current_text: String = ""
var tween: Tween

func display() -> void:
	
	visible = true
	panel.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)
	tween.tween_interval(2.0)
	tween.tween_property(panel, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(func():
		visible = false
	)
