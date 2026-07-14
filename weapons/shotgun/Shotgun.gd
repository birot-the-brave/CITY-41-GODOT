extends "res://scripts/classes/GunBase.gd"

func _ready() -> void:
	fire_rate = 1.5
	reload_time = 2.0
	automatic = false

func _perform_shot() -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return

	var pellet_count: int = stats.get("pellet_count", 1)
	var spread_deg: float = stats.get("spread_deg", 0.0)

	for i in range(pellet_count):
		var spread_x: float = deg_to_rad(randf_range(-spread_deg, spread_deg))
		var spread_y: float = deg_to_rad(randf_range(-spread_deg, spread_deg))

		var dir: Vector3 = camera.global_transform.basis.z * -1.0
		dir = dir.rotated(camera.global_transform.basis.x, spread_y)
		dir = dir.rotated(camera.global_transform.basis.y, spread_x)

		var from: Vector3 = camera.global_position
		var to: Vector3 = from + dir * 100.0
		_raycast_hit(from, to)
