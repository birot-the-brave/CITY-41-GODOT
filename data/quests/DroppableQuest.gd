class_name DroppableQuest
extends Quest

@export var dropped: bool = false

func start_quest() -> void:
	if dropped:
		return

	pass

func drop_quest() -> void:
	dropped = true
