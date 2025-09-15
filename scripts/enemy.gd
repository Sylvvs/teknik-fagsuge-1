class_name EnemySignal_Enemy
extends Node2D


var health: int = 100:
	set(value):
		health = value
		if health <= 0:
			queue_free()
func apply_damage(amount : int):
	health -= amount
	print('hi')
	print(amount)
