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

func transition():
	var distance = owner.direction.length()
	if distance < 45:
		get_parent().call_deferred("change_state", "LuciferAttack1")
	elif distance > 130:
		get_parent().call_deferred("change_state", "LuciferMagicAttack")
func _process(delta: float) -> void:
	var distance = owner.direction.length()
	if distance >= 0 and distance <= 1000: 
		time += delta
	else:
		time = 0
	if time > counter_timer and not has_countered and not get_parent().current_state.name == "LuciferAttack1":
		has_countered = true
		transition_to_counterhit()
		time = 0
		counter_timer = randi_range(15,25)
	if time > counter_timer + 5:
		time = 0
		counter_timer = randi_range(15,25)
