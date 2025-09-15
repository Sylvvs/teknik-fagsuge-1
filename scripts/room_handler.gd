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
		
		if forcing_movement:
			var player_body = player.get_node("CharacterBody2D")
			player_body.velocity.x = forced_direction.x * player_body.SPEED
			player_body.velocity.y += player_body.GRAV * _delta
			player_body.move_and_slide()
		
		var clamped_pos = Vector2(
			clamp(desired_pos.x, map_left + half_screen.x, map_right - half_screen.x),
			clamp(desired_pos.y, map_top + half_screen.y, map_bottom - half_screen.y)
		)
		camera.global_position = clamped_pos
		#camera.global_position = player.get_node("CharacterBody2D").global_position


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
				player.name = "Player"
				player.get_node("CharacterBody2D").handler = self;
				
				player.position = child.position
				var screen_size = get_viewport().size
				
				if forced_direction.x < 0:
					player.position.x = map_right - 20
					player.get_node("CharacterBody2D").sprite.flip_h = true
				elif forced_direction.x > 0:
					player.position.x = map_left + 20
					player.get_node("CharacterBody2D").sprite.flip_h = false

		if child is Area2D:
			child.body_entered.connect(func(body):
				if body.get_parent() == player and forcing_movement == false:
					load_room_with_fade(child.name)
			)


func load_room_with_fade(id: String) -> void:
	forced_direction = calculate_leaving_direction()
	forcing_movement = true
	fade_to_black().connect("finished", Callable(self, "_on_fade_out_complete").bind(id))


func _on_fade_out_complete(id: String) -> void:
	load_room(id)
	fade_from_black().connect("finished", Callable(func():
		forcing_movement = false
	))

	
func fade_to_black(duration: float = 0.3) -> Tween:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, duration)
	return tween


func fade_from_black(duration: float = 0.3) -> Tween:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, duration)
	return tween

func calculate_leaving_direction() -> Vector2:
	if not player:
		return Vector2.ZERO

	var player_body = player.get_node("CharacterBody2D")
	var dist_left = player_body.global_position.x - map_left
	var dist_right = map_right - player_body.global_position.x

	var min_dist = min(dist_left, dist_right)
	
	if min_dist == dist_left:
		return Vector2(-1, 0)
	else: # min_dist == dist_right
		return Vector2(1, 0)

var forced_direction: Vector2 = Vector2.ZERO
var forcing_movement: bool = false
