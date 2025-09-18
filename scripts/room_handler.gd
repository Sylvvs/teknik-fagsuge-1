extends Node2D

@onready var player_scene: PackedScene = load("res://scenes/player.tscn")
@onready var ui_scene: PackedScene = load("res://scenes/UI/UI.tscn")

var current_room
var player: Node2D
var camera: Camera2D
var tilemap: TileMapLayer
var ui

var map_left: float
var map_top: float
var map_right: float
var map_bottom: float

signal player_entered()

func _ready() -> void:
	add_to_group("room_handler")
	ui = ui_scene.instantiate()
	get_parent().add_child(ui)
	if GameState.intro_watched:
		load_room("forest")
	else:
		load_room("control")
	FadeLayer.fade_out(0.5)

func _process(_delta: float) -> void:
	if camera and player:
		var half_screen = (get_viewport_rect().size / 2) / camera.zoom
		var desired_pos = player.get_node("CharacterBody2D").global_position

		if current_room.name == "BossRoom":
			if current_room.has_node("GolemBoss"):
				desired_pos = (desired_pos + current_room.get_node("GolemBoss").position) / 2

		if forcing_movement:
			var player_body = player.get_node("CharacterBody2D")
			player_body.velocity.x = forced_direction.x * player_body.SPEED
			player_body.velocity.y += player_body.GRAV * _delta
			player_body.move_and_slide()
			player_body.update_animations(1)
		
		var clamped_pos = Vector2(
			clamp(desired_pos.x, map_left + half_screen.x, map_right - half_screen.x),
			clamp(desired_pos.y, map_top + half_screen.y, map_bottom - half_screen.y)
		)
		camera.global_position = clamped_pos
		#camera.global_position = player.get_node("CharacterBody2D").global_position

var previous_hp = 10;
var previous_calm = 0;

func load_room(id: String) -> void:
	if current_room:
		if player:
			player.queue_free()
			previous_hp = player.get_node("CharacterBody2D").health
			previous_calm = player.get_node("CharacterBody2D").calm_energy
		current_room.queue_free()

	var next_room = load("res://scenes/%s.tscn" % id).instantiate()
	add_child(next_room)

	current_room = next_room
	tilemap = current_room.get_node("TileMapLayer")
	_update_map_bounds()
	handle_logic()

	camera = player.get_node("CharacterBody2D/Camera2D")
	ui.get_node("HUD").connect_to_player(player)
	
	var anim_player = current_room.get_node_or_null("AnimationPlayer")
	if anim_player:
		anim_player.animation_finished.connect(_on_room_animation_finished)
		anim_player.play("rah")
	

func _on_room_animation_finished(anim_name: String) -> void:
	if anim_name == "rah":
		FadeLayer.fade_in(0.3).connect("finished", Callable(func():
			GameState.intro_watched = true;
			load_room("forest")
			FadeLayer.fade_out(0.3)
		))

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
				player.get_node("CharacterBody2D").health = previous_hp
				player.get_node("CharacterBody2D").calm_energy = previous_calm
				
				player.position = child.position
				
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
	FadeLayer.fade_in(0.3).connect("finished", Callable(self, "_on_fade_out_complete").bind(id))


func _on_fade_out_complete(id: String) -> void:
	load_room(id)
	FadeLayer.fade_out(0.3).connect("finished", Callable(func():
		forcing_movement = false
		emit_signal("player_entered")
		forced_direction = Vector2.ZERO
	))

	
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
