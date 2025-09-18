extends Node

@export var initial_state : BatState
var current_state : BatState = null
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is BatState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect((on_child_transition))
	if states.size() > 0:
		current_state = states.values()[0]
		current_state.enter()


func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
	print(current_state)
