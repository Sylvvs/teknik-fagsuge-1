extends Control

@onready var health_bar = $UIMargin/VBoxContainer/HBoxContainer/HealthMargin/Health
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
	if !GameState.healPrompt and new_value < 5:
		var ui = get_tree().root.get_node("Ui/TutorialText")
		ui.display("You're hurt! Press %s to heal for 7 calm energy", "special attack")
		GameState.healPrompt = true
		
	if tween and tween.is_running():
		tween.kill()
	#830525
	var health_bar_gradiant = health_bar.texture_progress.gradient
	var hue_value = float(new_value)/10.0*(100.0/360.0)
	health_bar_gradiant.set_color(0.0, Color.from_hsv(hue_value, 1.0, 0.5))
	health_bar_gradiant.set_color(1.0, Color.from_hsv(hue_value, 1.0, 1.0))
	
	tween = create_tween()
	tween.tween_property(health_bar, "value", new_value, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
