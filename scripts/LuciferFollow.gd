extends LuciferState
var time = 0
var has_countered : bool = false
var counter_timer = randi_range(4,4)

func enter():
	super.enter()
	has_countered = false
	owner.set_physics_process(true)
	animation_player.play("run")

func exit():
	super.exit()
	owner.set_physics_process(false)
	has_countered = false

func transition_to_counterhit():
	get_parent().call_deferred("change_state", "CounterHit")

var magic_timer = 0;

func transition():
	var distance = owner.direction.length()
	if distance < 45:
		get_parent().call_deferred("change_state", "LuciferAttack1")
	elif distance > 130 and not magic_animation_player.is_playing() and magic_timer > 5:
		get_parent().call_deferred("change_state", "LuciferMagicAttack")
		magic_timer = 0
		
func _process(delta: float) -> void:
	magic_timer += delta;
	var distance = owner.direction.length()
	if distance >= 0 and distance <= 1000: 
		time += delta
	else:
		time = 0
	if time > counter_timer and not has_countered and get_parent().current_state.name == "LuciferFollow":
		has_countered = true
		transition_to_counterhit()
		time = 0
		counter_timer = randi_range(15,25)
	if time > counter_timer + 5:
		time = 0
		counter_timer = randi_range(15,25)
