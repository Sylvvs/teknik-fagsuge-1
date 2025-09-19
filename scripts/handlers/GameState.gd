extends Node2D

var bosses_defeated = {}
var intro_watched = false;
var current_room = "tutorial_place"
var calmPrompt = false;
var healPrompt = false;
var orb_obtained = false;

const SAVE_GAME_PATH := "user://file1.save"

signal boss_defeated

func boss_defeated_trigger():
	emit_signal("boss_defeated")

func _ready() -> void:
	get_tree().auto_accept_quit = false


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()

func reset_data():
	bosses_defeated = {}
	intro_watched = false;
	current_room = "tutorial_place"
	calmPrompt = false;
	healPrompt = false;
	orb_obtained = false;
	save_game()

func save_game():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	
	file.store_var(bosses_defeated)
	file.store_var(intro_watched)
	file.store_var(current_room)
	file.store_var(calmPrompt)
	file.store_var(healPrompt)
	file.store_var(orb_obtained)

func load_game():
	if FileAccess.file_exists(SAVE_GAME_PATH):
		var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
		bosses_defeated = file.get_var()
		intro_watched = file.get_var()
		current_room = file.get_var()
		calmPrompt = file.get_var()
		healPrompt = file.get_var()
		orb_obtained = file.get_var()
