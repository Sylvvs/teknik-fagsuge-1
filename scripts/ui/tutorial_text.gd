extends Control

@onready var label = $MarginContainer/RichTextLabel

var current_text: String = ""
var tween: Tween

func display(text: String, action: String) -> void:
	var key_text = get_input_action_key_name(action)
	var final_text = text % key_text

	if final_text == current_text and visible:
		return

	if tween and tween.is_running():
		tween.kill()

	current_text = final_text
	label.clear()
	label.text = final_text
	
	visible = true
	label.modulate.a = 0.0
	tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(func():
		visible = false
	)


func get_input_action_key_name(action: String) -> String:
	var events = InputMap.action_get_events(action)
	return events[0].as_text().trim_suffix(" (Physical)")
