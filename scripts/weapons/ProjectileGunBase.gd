extends "res://scripts/weapons/GunBase.gd"
class_name ProjectileGunBase

@export var projectile_scene: PackedScene
@export var muzzle_point: Node3D  # optional; falls back to camera position if unset

func _perform_shot() -> void:
	if not projectile_scene:
		push_warning("No projectile scene assigned to ", weapon_id)
		return

	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return

	var projectile: Projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)

	projectile.global_position = muzzle_point.global_position if muzzle_point else camera.global_position
	projectile.damage = stats.get("body_dmg", 0)
	projectile.head_damage = stats.get("head_dmg", 0)
	projectile.splash_radius = stats.get("splash_radius", 0.0)

	var direction: Vector3 = -camera.global_transform.basis.z
	var speed: float = stats.get("projectile_speed", 30.0)
	projectile.launch(direction, speed)
