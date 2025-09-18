extends LuciferState
var time = 0
var has_countered : bool = false
func enter():
	super.enter()
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
		
func _process(delta: float) -> void:
	var distance = owner.direction.length()
	if distance >= 0 and distance <= 1000: 
		time += delta
	else:
		time = 0
	if time > 5 and not has_countered:
		has_countered = true
		transition_to_counterhit()
		time = 0
	if time > 7: 
		time = 0
