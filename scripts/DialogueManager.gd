extends Node

var dialogue_data: Dictionary
var npc_states: Dictionary = {} 
var dialogue_box: CanvasLayer
var current_npc_id: String
var dialogue_waiting_close: bool = false


@onready var DialogueBoxScene := preload("res://scenes/dialogue_box2.tscn")

func _ready():
	dialogue_data = load_dialogue("res://dialogue.json")

func load_dialogue(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var text := file.get_as_text()
		var result = JSON.parse_string(text)
		if typeof(result) == TYPE_DICTIONARY:
			return result
	return {}

func start_dialogue(npc_id: String, speaker: String):
	var room_handler = get_tree().root.get_node("RoomHandler")
	var player = null;
	room_handler.forcing_movement = true
	
	
	for child in room_handler.get_children():
		if child.is_in_group("player"):
			player = child
			break
	player.get_node("CharacterBody2D").velocity = Vector2(0,0);
	player.get_node("CharacterBody2D").update_animations(1)
	
	
	current_npc_id = npc_id
	var state = npc_states.get(npc_id, "default")
	var npc_data = dialogue_data[npc_id]["states"][state]
	show_dialogue(npc_data, speaker)

func show_dialogue(state_data: Dictionary, speaker: String):
	if dialogue_box:
		return

	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.get_node("RoomHandler").add_child(dialogue_box)
	
	dialogue_box.speaker.text = speaker;

	var dialogues = state_data["dialogues"]
	_run_dialogue(dialogues[0]) 

func _run_dialogue(dialogue: Dictionary):
	var label: RichTextLabel = dialogue_box.label
	await _typewriter(label, dialogue["lines"])

	if dialogue.has("choices") and dialogue["choices"].size() > 0:
		var vbox: VBoxContainer = dialogue_box.vbox
		for choice in dialogue["choices"]:
			var btn := Button.new()
			btn.text = choice["text"]
			btn.pressed.connect(func():
				_run_choice(choice))
			vbox.add_child(btn)
	else:
		dialogue_waiting_close = true
func _run_choice(choice: Dictionary):
	var label: RichTextLabel = dialogue_box.label
	label.clear()
	
	var vbox: VBoxContainer = dialogue_box.vbox
	for child in vbox.get_children():
		child.queue_free()
		
	await _typewriter(label, choice["lines"])

	if choice.has("set_state"):
		npc_states[current_npc_id] = choice["set_state"]
		
	dialogue_waiting_close = true

func _typewriter(label: RichTextLabel, lines: Array) -> void:
	for line in lines:
		label.clear()
		label.append_text(line) # indlæs hele linen fordi bbcode
		label.visible_characters = 0

		while label.visible_characters < label.get_total_character_count():
			if Input.is_action_pressed("interact") and label.visible_characters > 10:
				label.visible_characters = label.get_total_character_count()
				break
			label.visible_characters += 1
			await get_tree().create_timer(0.03).timeout

		var waiting_for_input = true
		while waiting_for_input:
			await get_tree().process_frame
			if Input.is_action_just_pressed("interact"):
				waiting_for_input = false




func _close_dialogue():
	if dialogue_box:
		dialogue_box.queue_free()
		dialogue_box = null
		current_npc_id = ""
		get_tree().root.get_node("RoomHandler").forcing_movement = false
		dialogue_closed_recently = true
		
func _process(delta):
	if dialogue_closed_recently:
		dialogue_close_cooldown -= delta
		if dialogue_close_cooldown <= 0:
			dialogue_closed_recently = false
			dialogue_close_cooldown = 0.2
	elif dialogue_box and dialogue_waiting_close:
		if Input.is_action_just_pressed("interact"):
			_close_dialogue()
			dialogue_waiting_close = false

var dialogue_closed_recently: bool = false
var dialogue_close_cooldown: float = 0.2 
