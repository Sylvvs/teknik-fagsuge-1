extends Area2D

@export var npc_id: String
var player_in_range: bool = false

func _ready():
	if DialogueManager.get_npc_state("lucifer") != "core_given":
		DialogueManager.set_npc_state("lucifer", "awaiting_core")
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	
	if DialogueManager.get_npc_state("lucifer") == "core_given":
		hide_npc()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if not DialogueManager.dialogue_box and not DialogueManager.dialogue_closed_recently:
			DialogueManager.start_dialogue(npc_id, self.name)

func _on_dialogue_finished(_npc_id: String, new_state: String):
	if new_state == "core_given":
		self.get_node("CPUParticles2D").emitting = true;
		await get_tree().create_timer(0.4).timeout
		self.get_node("CPUParticles2D").emitting = false;
		hide_npc()
		
func hide_npc():
	monitoring = false;
	var sprite = $"../../../AnimatedSprite2D"
	sprite.visible = true
	sprite.play("default")
	self.get_node("Sprite2D").visible = false;
