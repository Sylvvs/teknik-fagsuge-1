extends LuciferState

@onready var lucifercollision = $"../../PlayerDetection/PlayerDetectionLucifer"
@onready var progress_bar = owner.find_child("ProgressBar")
var player_entered: bool = false:
	set(value):
		player_entered = value
		lucifercollision.set_deferred("disabled", value)
		progress_bar.set_deferred("visible", value)
		

func transition():
	if player_entered:
		get_parent().change_state("LuciferFollow")


#remember to use correct body_entered
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered = true
