class_name TargetDummy
extends Node3D

@export var max_health: int = 1000
var health: int

signal died

func _ready() -> void:
	health = max_health

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)
	print("dummy took ", amount, " damage!")
	if health <= 0:
		die()

func die() -> void:
	print("dummy died")
	died.emit()
	queue_free()
