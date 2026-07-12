class_name Interactable
extends Area3D

@export var prompt_text: String = "Interact"
@export var requires_mission_id: int = -1
@export var requires_objective_id: String = ""

func is_available() -> bool:
	if requires_objective_id == "":
		return true
	var progress: Dictionary = MissionManager.get_progress(requires_mission_id)
	if not progress.is_empty():
		return progress.get(requires_objective_id, false)
	# mission might already be completed entirely by this point
	return MissionManager.is_mission_completed(requires_mission_id)

func interact() -> void:
	pass  # override in subclasses
