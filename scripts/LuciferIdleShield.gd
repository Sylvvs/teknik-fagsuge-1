extends LuciferState
@onready var idle_shield : Area2D = $"../../Idleshield"
var knockback_time = 0
var knockback_time_max = 3.0
var knockback_dir
var knockback_strength = 3000
var shield_hit = false
func enter():
	super.enter()
	knockback_time = 0
	knockback_time_max = 3.0
	idle_shield.monitoring = true
	shield_hit = false
	animation_player.play("idleShield")
	await animation_player.animation_finished
	transition()
func exit():
	super.exit()
	idle_shield.monitoring = false

func _on_idleshield_area_entered(area: Area2D) -> void:
	print("hit")
	if area.owner and area.owner.is_in_group("player"):
		player = get_tree().get_first_node_in_group("player").get_node("CharacterBody2D")
		shield_hit = true
func _physics_process(delta):
	knockback_time += delta
	
	if knockback_time <= knockback_time_max and shield_hit:
		knockback_time = 0
		shield_hit = false
		knockback_strength = 3000
		knockback_dir = (player.global_position - owner.position).normalized()
		player.position.y -= 1
		player.velocity = knockback_strength * knockback_dir
		player.move_and_slide()
		
func transition():
	if animation_player.is_playing():
		return
	else:
		get_parent().change_state("LuciferFollow")
