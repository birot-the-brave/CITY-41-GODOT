extends "res://scripts/weapons/Weapon.gd"

@export var fire_rate: float = 0.175
@export var reload_time: float = 2.6

var can_fire: bool = true
var is_reloading: bool = false
var stats: Dictionary = {}

func set_stats(s: Dictionary) -> void:
	stats = s

func _get_stats() -> Dictionary:
	return WeaponDatabase.DATABASE[weapon_id].stats

func _physics_process(_delta: float) -> void:
	if is_reloading:
		return

	if Input.is_action_pressed("Fire") and can_fire:
		_fire()

	if Input.is_action_just_pressed("Reload"):
		_reload()

func _fire() -> void:
	if magazine <= 0:
		_reload()
		return

	can_fire = false
	magazine -= 1

	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera:
		var from: Vector3 = camera.global_position
		var to: Vector3 = from + camera.global_transform.basis.z * -100.0

		var query := PhysicsRayQueryParameters3D.create(from, to)
		var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)

		if result.has("collider"):
			var target: Object = result["collider"]
			var stats: Dictionary = _get_stats()
			if target.has_method("take_damage"):
				target.take_damage(stats.get("body_dmg", 0))

	save_state()

	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _reload() -> void:
	var stats: Dictionary = _get_stats()
	var mag_size: int = stats.get("mag_size", 0)
	var needed: int = mag_size - magazine

	if needed <= 0 or reserve <= 0:
		return

	is_reloading = true
	await get_tree().create_timer(reload_time).timeout

	var amount: int = min(needed, reserve)
	magazine += amount
	reserve -= amount
	is_reloading = false

	save_state()
