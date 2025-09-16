extends CanvasLayer

@onready var panel = $Panel
@onready var label = panel.get_node("Dialogue") as RichTextLabel
@onready var vbox = panel.get_node("DialogueOptions") as VBoxContainer
@onready var speaker = panel.get_node("Name") as RichTextLabel

func _ready():
	_load_dialogue_effects()

func _load_dialogue_effects():
	var effects_path = "res://scripts/dialogueEffects/"
	var dir = DirAccess.open(effects_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				var effect_path = effects_path + file_name
				var script = load(effect_path)
				if script and script is Script:
					var effect_instance = script.new()
					if effect_instance is RichTextEffect:
						label.install_effect(effect_instance)
			file_name = dir.get_next()
		dir.list_dir_end()
