extends LuciferState

@onready var magic = $"../../Magic"
var can_transition : bool = false

func enter():
	super.enter()
	owner.set_physics_process(true)
	await play_animation("shootEffect")
	can_transition = true
func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func set_target():
	magic.rotation = (owner.direction - magic.position).normalized().angle()


func transition(): 
	if can_transition:
		can_transition = false
		get_parent().call_deferred("change_state", "LuciferFollow")
