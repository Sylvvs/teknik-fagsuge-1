extends CanvasLayer

@onready var panel = $Panel
@onready var label = panel.get_node("Dialogue") as RichTextLabel
@onready var vbox = panel.get_node("DialogueOptions") as VBoxContainer
@onready var speaker = panel.get_node("Name") as RichTextLabel
