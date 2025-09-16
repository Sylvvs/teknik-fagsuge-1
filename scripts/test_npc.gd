extends Area2D

@export var npc_id: String
var player_in_range: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if not DialogueManager.dialogue_box and not DialogueManager.dialogue_closed_recently:
			DialogueManager.start_dialogue(npc_id, self.name)
