extends Node2D

@onready var player : PackedScene = load("res://scenes/player.tscn")

func _ready() -> void:
	var playerModel = player.instantiate()
	add_child(playerModel)
