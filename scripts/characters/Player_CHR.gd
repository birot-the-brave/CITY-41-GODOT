extends CharacterBody3D


var save_path : String = "user://save/"
var save_name : String = "PlayerSave.tres"
var playerData = PlayerData.new()

var speed = WALK_SPEED
const WALK_SPEED := 5.0
const JUMP_VELOCITY := 5.0
const SPRINT_SPEED := 8.0

func _ready() -> void:
	verify_save_directory(save_path)

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		playerData.change_health(-5)

	if !Input.is_action_pressed("Sprint"):
		speed = WALK_SPEED
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED

	if Input.is_action_just_pressed("Pause"):
		get_tree().quit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()

func _process(delta: float) -> void:
	$HUD/Label.text = str(playerData.health)
	if Input.is_action_just_pressed("save"):
		save_data()
	if Input.is_action_just_pressed("load"):
		load_data()
	playerData.UpdatePos(self.position)

func load_data():
	if (ResourceLoader.exists(save_path + save_name)):
		playerData = ResourceLoader.load(save_path + save_name).duplicate()
	on_start_load()
	print("File Loaded")

func on_start_load():
	self.position = playerData.SavePos

func save_data():
	ResourceSaver.save(playerData, save_path + save_name)
	print("File Saved")
