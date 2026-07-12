extends Area3D
class_name MissionTrigger

@export var mission_id: int = -1
@export var objective_id: String = ""
@export var one_shot: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player"):
		return
	if mission_id == -1 or objective_id == "":
		return
	if not MissionManager.is_mission_active(mission_id):
		return

	MissionManager.complete_objective(mission_id, objective_id)

	if one_shot:
		set_deferred("monitoring", false)
