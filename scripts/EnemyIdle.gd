extends EnemyState

@onready var enemycollision = $"../../PlayerDetection/PlayerDetection"

var player_entered: bool = false:
	set(value):
		print(value)
		player_entered = value
		enemycollision.set_deferred("disabled", value)

func transition():
	if player_entered:
		get_parent().change_state("EnemyRun")

func player_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_entered = true
	
