extends Control

@onready var start_button = $VBoxContainer/VBoxContainer/StartContainer/Start
@onready var fade_rect = $CanvasLayer/Fade

func _ready() -> void:
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
	print("slow it down bro im not that far yet")



func _on_quit_pressed() -> void:
	print("hold your horses")
