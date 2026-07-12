extends StaticBody3D
class_name Generator

signal disabled

@export var mission_id: int = -1
@export var objective_id: String = ""

var is_disabled: bool = false

func take_damage(_amount: int) -> void:
	if is_disabled:
		return
	is_disabled = true
	disabled.emit()
	if is_disabled:
		print("Disabled generator.")

	if mission_id != -1 and objective_id != "" and MissionManager.is_mission_active(00):
		MissionManager.complete_objective(00, "lure")
