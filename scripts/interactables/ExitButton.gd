extends Interactable

@export var door_collision_shape: CollisionShape3D
@export var door_node: Node3D

func interact() -> void:
	if not is_available():
		return
	if door_collision_shape:
		door_collision_shape.disabled = true
	if door_node:
		door_node.visible = false
	if MissionManager.is_mission_active(00):
		MissionManager.complete_objective(00, "button")
