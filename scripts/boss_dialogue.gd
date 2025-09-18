extends Area2D

@export var npc_id: String
var player_in_range: bool = false

func _ready() -> void:
	var room_handler = get_tree().get_first_node_in_group("room_handler")
	if room_handler:
		room_handler.connect("player_entered", Callable(self, "_start_dialogue"))

func _start_dialogue() -> void:
	if not DialogueManager.dialogue_box and not DialogueManager.dialogue_closed_recently:
		if "Golem" in GameState.bosses_defeated and GameState.bosses_defeated["Golem"]:
			DialogueManager.start_dialogue(npc_id, self.name)
