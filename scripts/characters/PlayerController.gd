extends CharacterBody3D
var speed: float = WALK_SPEED
const WALK_SPEED := 5.0
const JUMP_VELOCITY := 5.0
const SPRINT_SPEED := 8.0
const MELEE_DAMAGE := 75
const MELEE_RANGE := 2.0
const MELEE_COOLDOWN := 0.5
const MOUSE_SENSITIVITY := 0.003
const PITCH_MIN := deg_to_rad(-89.0)
const PITCH_MAX := deg_to_rad(89.0)

@onready var camera_pivot: Node3D = $Head

@export var weapon_wheel: Control
@export var weapon_manager: Node3D

var melee_cooldown_timer: float = 0.0

func _ready() -> void:
	if PlayerData.has_saved_position:
		position = PlayerData.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameEvents.pause_requested.connect(_on_paused)
	GameEvents.game_resumed.connect(_on_resumed)
	$HUD.connect_weapon_manager(weapon_manager)

func _on_paused() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_resumed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause") and not get_tree().paused:
		GameEvents.pause_requested.emit()
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("WeaponWheel"):
		_open_weapon_wheel()
	if event.is_action_released("WeaponWheel"):
		_close_weapon_wheel()

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, PITCH_MIN, PITCH_MAX)

	# Melee attack (F key or right stick click)
	if Input.is_action_just_pressed("Melee") and melee_cooldown_timer <= 0.0:
		_perform_melee_attack()

func _open_weapon_wheel() -> void:
	if PlayerData.weapons["wheel_order"].is_empty():
		return
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Engine.time_scale = 0.15
	weapon_wheel.open()

func _close_weapon_wheel() -> void:
	var id: String = weapon_wheel.get_selected_id()
	weapon_wheel.close()
	Engine.time_scale = 1.0
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if id != "":
		weapon_manager.equip_weapon(id)

func _debug_unlock_all_weapons() -> void:
	for id in WeaponDatabase.DATABASE.keys():
		PlayerData.unlock_weapon(id)
	print("Debug: unlocked all weapons.")

func _perform_melee_attack() -> void:
	# Start cooldown
	melee_cooldown_timer = MELEE_COOLDOWN

	# Get camera for direction and range
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return

	var from: Vector3 = camera.global_position
	var direction: Vector3 = -camera.global_transform.basis.z  # Forward direction
	var to: Vector3 = from + direction * MELEE_RANGE

	# Perform raycast to detect targets in melee range
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)

	if result.has("collider"):
		var collider: Object = result["collider"]
		# Check if it's an enemy or damageable object
		if collider.has_method("take_damage"):
			var damage_dealt: int = MELEE_DAMAGE
			collider.take_damage(damage_dealt)

func _process(delta: float) -> void:
	# Update melee cooldown timer
	if melee_cooldown_timer > 0.0:
		melee_cooldown_timer -= delta

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		PlayerData.health = clamp(PlayerData.health - 5, 0, 100)
		if MissionManager.is_mission_active(00):
			MissionManager.complete_objective(00, "jump")

	if !Input.is_action_pressed("Sprint"):
		speed = WALK_SPEED
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
		if is_on_floor() and MissionManager.is_mission_active(00):
			MissionManager.complete_objective(00, "sprint")
	if Input.is_action_pressed("Crouch"):
		pass
		if MissionManager.is_mission_active(00):
			MissionManager.complete_objective(00, "crouch")

	if OS.is_debug_build() and Input.is_action_just_pressed("DebugUnlockAll"):
		_debug_unlock_all_weapons()

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if MissionManager.is_mission_active(00):
			MissionManager.complete_objective(00, "walk")
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	PlayerData.position = position
