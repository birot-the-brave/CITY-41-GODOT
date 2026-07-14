extends StaticBody3D
class_name Generator

signal disabled

@export var mission_id: int = -1
@export var objective_id: String = ""
@export var wake_points: Array[Node3D] = []

var is_disabled: bool = false

func take_damage(_amount: int) -> void:
	if is_disabled:
		return
	is_disabled = true
	disabled.emit()

	if mission_id != -1 and objective_id != "" and MissionManager.is_mission_active(mission_id):
		MissionManager.complete_objective(mission_id, objective_id)

	var wakeable_grunts: Array = []
	for grunt in get_tree().get_nodes_in_group("Grunts"):
		if grunt.get("wakeable_by_generator") == true:
			wakeable_grunts.append(grunt)

	for i in range(wakeable_grunts.size()):
		var target: Node3D = wake_points[i % wake_points.size()] if not wake_points.is_empty() else null
		if target and wakeable_grunts[i].has_method("wake_up"):
			wakeable_grunts[i].wake_up(target.global_position)
