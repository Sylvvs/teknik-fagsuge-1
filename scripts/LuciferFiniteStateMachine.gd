extends Node2D

var current_state: LuciferState
var previous_state: LuciferState

func _ready():
	current_state = get_child(0) as LuciferState
	previous_state = current_state
	current_state.enter()


func change_state(state):
	current_state = find_child(state) as LuciferState
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
