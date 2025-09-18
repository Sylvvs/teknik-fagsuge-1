extends LuciferState
var time = 0
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("run")

func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	var distance = owner.direction.length()
	if distance < 45:
		get_parent().change_state("LuciferAttack1")
		print(time)
	if time >= 10:#replace:
		#get_parent().change_state("CounterHit")
		get_parent().change_state("Counter2")
	
func _process(delta: float) -> void:
	var distance = owner.direction.length()
	if distance >= 0 and distance <= 500: 
		time += delta
	else:
		time = 0
	
