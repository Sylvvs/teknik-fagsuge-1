extends Control

@onready var input_settings_scene = preload("res://scenes/InputSettings.tscn")
var input_settings

func _ready() -> void:
	GameState.load_game()
	var ui := get_tree().root.get_node_or_null("Ui")
	if ui:
		ui.queue_free()
	var buttons = [
		$VBoxContainer/VBoxContainer/StartContainer/Start,
		$VBoxContainer/VBoxContainer/SettingsContainer/Settings,
		$VBoxContainer/VBoxContainer/QuitContainer/Quit
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


func _on_start_pressed() -> void:
	FadeLayer.fade_in(0.3).connect("finished", Callable(get_tree(), "change_scene_to_file").bind("res://scenes/room_handler.tscn"))


func _on_settings_pressed() -> void:
	input_settings = input_settings_scene.instantiate()
	add_child(input_settings)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if input_settings and input_settings.get_parent():
			input_settings.queue_free()
			input_settings = null

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	GameState.reset_data()
	GameState.load_game()
	$Button.text = "okay its done"
