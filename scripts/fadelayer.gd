extends CanvasLayer

@onready var rect: ColorRect = $Fade

signal fade_in_finished
signal fade_out_finished

func fade_in(duration: float = 1.0) -> Tween:
	rect.visible = true
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, duration)
	tween.finished.connect(emit_signal.bind("fade_in_finished"))
	return tween

func fade_out(duration: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 0.0, duration)
	tween.finished.connect(func():
		rect.visible = false
		emit_signal("fade_out_finished")
		)
	return tween
