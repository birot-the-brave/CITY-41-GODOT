extends "res://scripts/weapons/Weapon.gd"
class_name GunBase

@export var fire_rate: float = 0.25
@export var reload_time: float = 1.2
@export var automatic: bool = false # true = hold to fire, false = one shot per press

var stats: Dictionary = {}
var can_fire: bool = true
var is_reloading: bool = false


func set_stats(s: Dictionary) -> void:
	stats = s


func _physics_process(_delta: float) -> void:
	if is_reloading:
		return

	var wants_to_fire: bool = Input.is_action_pressed("Fire") if automatic else Input.is_action_just_pressed("Fire")

	if wants_to_fire and can_fire:
		_fire()

	if Input.is_action_just_pressed("Reload"):
		_reload()


func _fire() -> void:
	if magazine <= 0:
		_reload()
		return

	can_fire = false
	magazine -= 1

	_perform_shot()
	save_state()

	await get_tree().create_timer(fire_rate).timeout
	can_fire = true


func _perform_shot() -> void:
	# Default behavior: single hitscan ray.
	# Override in subclasses for shotguns/projectiles.
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return

	var from: Vector3 = camera.global_position
	var to: Vector3 = from + camera.global_transform.basis.z * -100.0

	_raycast_hit(from, to)


func _calculate_damage(base_damage: int) -> int:
	var variance: int = stats.get("damage_variance", 0)

	if variance <= 0:
		return base_damage

	# Two random rolls averaged together gives a nice bell-curve.
	var roll := (
		randi_range(-variance, variance) +
		randi_range(-variance, variance)
	) / 2

	return maxi(1, base_damage + roll)


func _raycast_hit(from: Vector3, to: Vector3) -> void:
	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)

	if not result.has("collider"):
		return

	var collider: Object = result["collider"]

	var is_headshot: bool = collider is StaticBody3D and collider.get("is_head") == true

	var base_damage: int = stats.get("head_dmg", 0) if is_headshot else stats.get("body_dmg", 0)
	var dmg: int = _calculate_damage(base_damage)

	if collider.has_method("take_damage"):
		collider.take_damage(dmg)

func _reload() -> void:
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
