extends CharacterBody3D
var speed: float = WALK_SPEED
const WALK_SPEED := 5.0
const JUMP_VELOCITY := 5.0
const SPRINT_SPEED := 8.0
const MOUSE_SENSITIVITY := 0.003
const PITCH_MIN := deg_to_rad(-89.0)
const PITCH_MAX := deg_to_rad(89.0)

@onready var camera_pivot: Node3D = $Head

func _ready() -> void:
	position = PlayerData.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameEvents.pause_requested.connect(_on_paused)
	GameEvents.game_resumed.connect(_on_resumed)

func _on_paused() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_resumed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause") and not get_tree().paused:
		GameEvents.pause_requested.emit()
		get_viewport().set_input_as_handled()

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, PITCH_MIN, PITCH_MAX)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		PlayerData.health = clamp(PlayerData.health - 5, 0, 100)

	if !Input.is_action_pressed("Sprint"):
		speed = WALK_SPEED
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	PlayerData.position = position
