extends Node2D

var max_calm = 10
var radius = 60
var thickness = 10
var gap_degrees = 3.0
var outline = 2

var current_calm := 0

func _draw():
	var slice_angle = 360.0 / max_calm - gap_degrees
	var rotation_offset = deg_to_rad(-90)
	for i in range(max_calm):
		var start_angle = deg_to_rad(i * (slice_angle + gap_degrees)) + rotation_offset
		var end_angle = start_angle + deg_to_rad(slice_angle)
		
		var color = Color(0.2,0.2,0.2,0.3)
		if i < current_calm:
			color = Color(0.0, 0.469, 0.972, 1.0)
			
			draw_arc(Vector2.ZERO, radius-outline, start_angle-deg_to_rad(outline), end_angle+deg_to_rad(outline), 10, Color(0,0,0,1), thickness)
			draw_arc(Vector2.ZERO, radius+outline, start_angle-deg_to_rad(outline), end_angle+deg_to_rad(outline), 10, Color(0,0,0,1), thickness)
		
		draw_arc(Vector2.ZERO, radius, start_angle, end_angle, 10, color, thickness)

		


func set_calm(value: int) -> void:
	current_calm = clamp(value, 0, max_calm)
	queue_redraw()
