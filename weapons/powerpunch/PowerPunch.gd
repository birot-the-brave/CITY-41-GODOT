extends "res://scripts/classes/GunBase.gd"

@export var punch_range: float = 2.0

var _ready_to_punch: bool = true
var _cooldown_timer: float = 0.0

func _ready() -> void:
	_cooldown_timer = 0.0
	if magazine == 0:
		_cooldown_timer = stats.get("fire_rate", 0.6)

func _process(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer = max(0.0, _cooldown_timer - delta)
		if _cooldown_timer <= 0.0:
			magazine = 1
			ammo_changed.emit(magazine, reserve)

func _physics_process(_delta: float) -> void:
	var cam: Camera3D = get_viewport().get_camera_3d()
	if not cam:
		return

	var wants_to_fire: bool
	if stats.get("automatic", false):
		wants_to_fire = Input.is_action_pressed("Fire")
	else:
		wants_to_fire = Input.is_action_just_pressed("Fire")

	if wants_to_fire and _cooldown_timer <= 0.0:
		magazine = 0
		ammo_changed.emit(magazine, reserve)
		_cooldown_timer = stats.get("fire_rate", 0.6) 
		_perform_shot()

	if Input.is_action_just_pressed("Reload"):
		pass

func _perform_shot() -> void:
	var cam: Camera3D = get_viewport().get_camera_3d()
	var from: Vector3
	var forward: Vector3
	if cam:
		from = cam.global_position
		forward = -cam.global_transform.basis.z
	else:
		from = Vector3.ZERO
		forward = Vector3.FORWARD

	var to: Vector3 = from + forward * punch_range

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)

	if result.has("collider"):
		var collider: Object = result["collider"]
		if collider.has_method("take_damage"):
			var is_headshot: bool = collider.has_method("is_head") and collider.is_head()
			var base_damage: int = stats.get("head_dmg", 0) if is_headshot else stats.get("body_dmg", 0)
			var variance: int = stats.get("damage_variance", 0)
			var final_damage: int = base_damage + randi_range(-variance, variance)
			final_damage = maxi(1, final_damage)
			collider.take_damage(final_damage)
	save_state()
	_ready_to_punch = true

func _reload() -> void:
	pass
