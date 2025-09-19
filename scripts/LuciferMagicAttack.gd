extends LuciferState

@onready var magic = $"../../Magic"



func enter():
	super.enter()
	magic_animation_player.play("Magic")
	await magic_animation_player.animation_finished

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func set_target():
	var dir = (owner.direction - magic.position).normalized()
	var angle = dir.angle() - deg_to_rad(26)
	magic.rotation = angle


func transition(): 
	get_parent().call_deferred("change_state", "LuciferFollow")
