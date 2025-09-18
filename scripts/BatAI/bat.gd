extends CharacterBody2D
class_name BatEnemy

@onready var anim = $"Animation handler Bat/AnimationPlayer"

func _physics_process(delta: float) -> void:
	move_and_slide()
