extends LuciferState
@onready var sprite = $"../../Lucifer Animation Handler/Animation virk pls/Lucifer"



func enter():
	super.enter()
	sprite.material.set_shader_parameter("flash_strength", 1.0)
	# await animation_player.play(insert mikkel flash ting)
	

func exit():
	super.exit()
	sprite.material.set_shader_parameter("flash_strength", 0.0)

func play_animation(anim_name: String, speed: float = 1.0):
	animation_player.play(anim_name, -1.0, speed)
	await animation_player.animation_finished
	if owner.direction.length() < 45:
		play_animation(anim_name, speed)
	


func transition():
	var chance = randi() % 2
	match chance:
		0:
			get_parent().change_state("Counter1")
		1:
			get_parent().change_state("Counter2")

func _on_counter_area_entered(area: Area2D) -> void:
	print('area ', area)
	if area.owner:
		if area.owner.is_in_group('player'):
			transition()
