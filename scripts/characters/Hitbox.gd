extends StaticBody3D

@export var is_head: bool = false
@export var target: TargetDummy

func take_damage(amount: int) -> void:
	target.take_damage(amount)
