extends LuciferState

@onready var magic = $"../../Magic"
@export var beam_node: PackedScene


func enter():
	super.enter()
	magic_animation_player.play("Magic")
	await magic_animation_player.animation_finished

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func launch_projectie():
	var beam = beam_node.instantiate()
	beam.position = owner.position 
	get_tree().current_scene.add_child(beam)

func transition(): 
	get_parent().call_deferred("change_state", "LuciferFollow")
