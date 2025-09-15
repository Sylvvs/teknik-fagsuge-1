extends Node

var dialogue_data: Dictionary
var npc_states: Dictionary = {} 
var dialogue_box: Control
var current_npc_id: String

@onready var DialogueBoxScene := preload("res://scenes/dialogue_box.tscn")

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

func start_dialogue(npc_id: String):
	current_npc_id = npc_id
	var state = npc_states.get(npc_id, "default")
	var npc_data = dialogue_data[npc_id]["states"][state]
	show_dialogue(npc_data)

func show_dialogue(state_data: Dictionary):
	if dialogue_box:
		dialogue_box.queue_free()

	dialogue_box = DialogueBoxScene.instantiate()
	get_tree().root.add_child(dialogue_box)

	var dialogues = state_data["dialogues"]
	_run_dialogue(dialogues[0]) 

func _run_dialogue(dialogue: Dictionary):
	var label: RichTextLabel = dialogue_box.get_node("RichTextLabel")
	await _typewriter(label, dialogue["lines"])

	if dialogue.has("choices"):
		var vbox: VBoxContainer = dialogue_box.get_node("VBoxContainer")
		for choice in dialogue["choices"]:
			var btn := Button.new()
			btn.text = choice["text"]
			btn.pressed.connect(func():
				_run_choice(choice))
			vbox.add_child(btn)

func _run_choice(choice: Dictionary):
	var label: RichTextLabel = dialogue_box.get_node("RichTextLabel")
	label.clear()
	await _typewriter(label, choice["lines"])

	if choice.has("set_state"):
		npc_states[current_npc_id] = choice["set_state"]

	var vbox: VBoxContainer = dialogue_box.get_node("VBoxContainer")
	vbox.queue_free()

func _typewriter(label: RichTextLabel, lines: Array) -> void:
	for line in lines:
		label.text = ""
		for i in range(line.length()):
			label.text += line[i]
			await get_tree().create_timer(0.05).timeout
		await get_tree().create_timer(0.5).timeout
