extends Node2D

@onready var player_scene: PackedScene = load("res://scenes/player.tscn")
@onready var fade_rect: ColorRect = get_node("CanvasLayer/Fade")

var current_room: Node2D
var player: Node2D
var camera: Camera2D
var tilemap: TileMapLayer

var map_left: float
var map_top: float
var map_right: float
var map_bottom: float


func _ready() -> void:
	fade_rect.size = get_viewport().size
	load_room("forest")

func _process(_delta: float) -> void:
	if camera and player:
		var half_screen = (get_viewport_rect().size / 2) / camera.zoom
		var desired_pos = player.get_node("CharacterBody2D").global_position
		var clamped_pos = Vector2(
			clamp(desired_pos.x, map_left + half_screen.x, map_right - half_screen.x),
			clamp(desired_pos.y, map_top + half_screen.y, map_bottom - half_screen.y)
		)
		camera.global_position = clamped_pos


func load_room(id: String) -> void:
	var next_room = load("res://scenes/%s.tscn" % id).instantiate()
	add_child(next_room)
	
	if current_room:
		if player:
			player.queue_free()
		current_room.queue_free()

	current_room = next_room
	tilemap = current_room.get_node("TileMapLayer")
	_update_map_bounds()
	handle_logic()

	camera = player.get_node("CharacterBody2D/Camera2D")
	

func _update_map_bounds() -> void:
	var used_rect = tilemap.get_used_rect()
	var cell_size = tilemap.tile_set.tile_size

	map_left = tilemap.position.x + used_rect.position.x * cell_size.x
	map_top = tilemap.position.y + used_rect.position.y * cell_size.y
	map_right = map_left + used_rect.size.x * cell_size.x
	map_bottom = map_top + used_rect.size.y * cell_size.y


func handle_logic() -> void:
	var logic_node = current_room.get_node("Logic")
	for child in logic_node.get_children():
		match child.name:
			"Spawn":
				player = player_scene.instantiate()
				add_child(player)
				player.position = child.position
			"IdkGoblinMaybe":
				print("hi twin")

		if child is Area2D:
			child.body_entered.connect(func(body):
				if body.name == "CharacterBody2D":
					load_room_with_fade(child.name)
			)


func load_room_with_fade(id: String) -> void:
	fade_to_black().connect("finished", Callable(self, "_on_fade_out_complete").bind(id))


func _on_fade_out_complete(id: String) -> void:
	load_room(id)
	fade_from_black()


func fade_to_black(duration: float = 0.5) -> Tween:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, duration)
	return tween


func fade_from_black(duration: float = 0.5) -> Tween:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, duration)
	return tween
