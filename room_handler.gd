extends Node2D

var current_room = "none";
	
func load_room(id):
	var next_room = load("res://scenes/"+id+".tscn").instantiate()
	print(next_room)
	add_child(next_room)
	
	if current_room != "none":
		current_room.queue_free()
	
	current_room = next_room
	# current_room.connect("level_changed", Callable(self, "load_room"))
	
	tilemap = current_room.get_node("TileMapLayer") 
	
	player = player_scene.instantiate()
	add_child(player)

	camera = player.get_node("CharacterBody2D/Camera2D")

	var used_rect = tilemap.get_used_rect()  
	var cell_size = tilemap.tile_set.tile_size

	map_left = tilemap.position.x + used_rect.position.x * cell_size.x
	map_top = tilemap.position.y + used_rect.position.y * cell_size.y
	map_right = map_left + used_rect.size.x * cell_size.x
	map_bottom = map_top + used_rect.size.y * cell_size.y

@onready var player_scene : PackedScene = load("res://scenes/player.tscn")
var tilemap 
var player
var camera

var map_left: float
var map_top: float
var map_right: float
var map_bottom: float

func _process(_delta: float) -> void:
	if camera:
		var half_screen = (get_viewport_rect().size / 2) / camera.zoom
		var desired_pos = player.get_node("CharacterBody2D").global_position

		var clamped_x = clamp(desired_pos.x, map_left + half_screen.x, map_right - half_screen.x)
		var clamped_y = clamp(desired_pos.y, map_top + half_screen.y, map_bottom - half_screen.y)

		camera.global_position = Vector2(clamped_x, clamped_y)

func _ready() -> void:
	load_room("forest")
