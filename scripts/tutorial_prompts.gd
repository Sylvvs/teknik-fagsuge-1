extends Node2D

func _ready():
	for child in get_children():
		if child is Area2D and child.has_method("get"):
			child.body_entered.connect(
				func(body):
					if body.is_in_group("player"):
						var ui = get_tree().root.get_node("Ui/TutorialText")
						ui.display(child.text, child.action)
			)
