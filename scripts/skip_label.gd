extends RichTextLabel

@export var action_name: String = "interact"

func _ready():
	var key_text = get_input_action_key_name(action_name)
	clear()
	text = ("[b]Press %s to skip[/b]" % key_text)


func get_input_action_key_name(action: String) -> String:
	var events = InputMap.action_get_events(action)
	return events[0].as_text().trim_suffix(" (Physical)")
