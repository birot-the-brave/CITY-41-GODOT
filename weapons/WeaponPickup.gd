extends Area3D
@export var id: String = ""
@export var required_mission_id: int = -1
@export var required_objective_id: String = ""

func _ready() -> void:
	if required_objective_id != "":
		monitoring = false
		visible = false
		MissionManager.objective_completed.connect(_on_objective_completed)
		_check_unlock()  # in case the objective was already done before this loaded (e.g. from a save)
		if PlayerData.owns_weapon(id):
			queue_free()

func _check_unlock() -> void:
	var progress: Dictionary = MissionManager.get_progress(required_mission_id)
	if progress.get(required_objective_id, false):
		_unlock()

func _on_objective_completed(mission_id: int, objective: String) -> void:
	if mission_id == required_mission_id and objective == required_objective_id:
		_unlock()

func _unlock() -> void:
	monitoring = true
	visible = true

func _on_body_entered(body: Node3D) -> void:
	if id == "":
		return
	if not body.is_in_group("Player"):
		return
	if PlayerData.owns_weapon(id):
		return

	PlayerData.unlock_weapon(id)
	print("Weapon collected: ", id)

	if id == "power_punch" and MissionManager.is_mission_active(00):
		MissionManager.complete_objective(00, "collect_1")

	queue_free()
