extends Control

@onready var health_bar: ProgressBar = $UIMargin/VBoxContainer/HBoxContainer/HealthMargin/Health
@onready var calm_ring: Node2D = $UIMargin/VBoxContainer/HBoxContainer/IconMargin/CalmRing

var tween: Tween

func _ready() -> void:
	tween = create_tween()

func connect_to_player(player: Node) -> void:
	player.get_node("CharacterBody2D").health_changed.connect(_on_player_health_changed)
	player.get_node("CharacterBody2D").calm_changed.connect(_on_player_calm_changed)

func _on_player_health_changed(current: int) -> void:
	set_health(current)

func _on_player_calm_changed(current: int) -> void:
	calm_ring.set_calm(current)

func set_health(new_value: int) -> void:
	if tween and tween.is_running():
		tween.kill()
	#830525
	var health_bar_stylebox = health_bar.get_theme_stylebox("fill")
	var hue_value = float(new_value)/10.0*(100.0/360.0)
	health_bar_stylebox.bg_color = Color.from_hsv(hue_value, 1.0, 0.5)
	
	tween = create_tween()
	tween.tween_property(health_bar, "value", new_value, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
