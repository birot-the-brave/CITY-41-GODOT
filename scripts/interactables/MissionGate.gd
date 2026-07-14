extends StaticBody3D
class_name MissionGate

@export var mission_id: int = -1
@export var required_objective_id: String = ""
@export var navigation_region: NavigationRegion3D

func _ready() -> void:
	if required_objective_id == "":
		return
	MissionManager.objective_completed.connect(_on_objective_completed)
	_check_unlock()

func _check_unlock() -> void:
	var progress: Dictionary = MissionManager.get_progress(mission_id)
	if progress.get(required_objective_id, false):
		_unlock()

func _on_objective_completed(id: int, objective: String) -> void:
	if id == mission_id and objective == required_objective_id:
		_unlock()

func _unlock() -> void:
	if navigation_region:
		GameEvents.nav_rebake_requested.emit(navigation_region)
	queue_free()
