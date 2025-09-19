extends Control

@onready var input_settings_scene = preload("res://scenes/InputSettings.tscn")
var input_settings

func _ready() -> void:
	var buttons = [
		$Panel/VBoxContainer/ResumeContainer/Resume,
		$Panel/VBoxContainer/SettingsContainer/Settings,
		$Panel/VBoxContainer/QuitContainer/Title
	]
	for button in buttons:
		button.mouse_entered.connect(func(): _on_button_hovered(button))
		button.mouse_exited.connect(func(): _on_button_exited(button))
		button.pivot_offset = button.size / 2

func _on_button_hovered(button) -> void:
	var tween = button.create_tween()
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func _on_button_exited(button) -> void:
	var tween = button.create_tween()
	tween.tween_property(button, "scale", Vector2(1, 1), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_settings_pressed() -> void:
	input_settings = input_settings_scene.instantiate()
	add_child(input_settings)

func _input(event):
	var room_handler = get_tree().root.get_node("RoomHandler")
	if event.is_action_pressed("ui_cancel"):
		if input_settings and input_settings.get_parent():
			input_settings.queue_free()
			input_settings = null
		elif !visible:
			visible = true;
			room_handler.forcing_movement = true
		else:
			visible = false;
			room_handler.forcing_movement = false

func _on_title_pressed() -> void:
	FadeLayer.fade_in(0.3).connect("finished", Callable(func():
		FadeLayer.fade_out(0.3)
		GameState.save_game()
		get_tree().change_scene_to_file("res://scenes/titlescreen.tscn")
		
	))


func _on_resume_pressed() -> void:
	var room_handler = get_tree().root.get_node("RoomHandler")
	visible = false;
	room_handler.forcing_movement = false
	
