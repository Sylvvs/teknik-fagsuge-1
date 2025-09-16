extends CanvasLayer

@onready var rect: ColorRect = $Fade
@onready var slide: ColorRect = $Slide

signal fade_in_finished
signal fade_out_finished
signal slide_in_finished
signal slide_out_finished

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

func slide_in(duration: float = 1.0, angle_degrees: float = 0.0) -> Tween:
	var screen_size = get_viewport().size
	slide.size = screen_size
	
	var dir = Vector2.RIGHT.rotated(deg_to_rad(angle_degrees))
	
	slide.position = -dir * screen_size.length()
	slide.visible = true

	var tween = create_tween()
	tween.tween_property(slide, "position", Vector2(0, 0), duration)
	tween.finished.connect(emit_signal.bind("slide_in_finished"))
	return tween


func slide_out(duration: float = 1.0, angle_degrees: float = 0.0) -> Tween:
	var screen_size = get_viewport().size
	var dir = Vector2.RIGHT.rotated(deg_to_rad(angle_degrees))

	var tween = create_tween()
	tween.tween_property(slide, "position", dir * screen_size.length(), duration)
	tween.finished.connect(func():
		slide.visible = false
		emit_signal("slide_out_finished")
	)
	return tween
