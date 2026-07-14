extends EnemyBase
class_name GruntBase

enum State { DORMANT, PATROL, ALERT, COMBAT }

const ROTATION_SPEED := 10.0
const ARRIVAL_SLOWDOWN_RADIUS := 1.0
const NAV_TOLERANCE := 0.2
const LOSE_SIGHT_TIME := 4.0
const SEARCH_GIVEUP_TIME := 3.0

@export var patrol_points: Array[Node3D] = []
@export var move_speed: float = 3.0
@export var vision_range: float = 15.0
@export var vision_angle_deg: float = 60.0
@export var fire_rate: float = 1.0
@export var damage: int = 10
@export var alert_radius: float = 20.0
@export var starts_dormant: bool = false
@export var wakeable_by_generator: bool = true

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var eyes: Node3D = self

var state: State
var patrol_index: int = 0
var player: Node3D
var can_fire: bool = true
var last_known_player_pos: Vector3
var wake_target_pos: Vector3

var can_see_player: bool = false
var lost_sight_timer: float = 0.0
var searching: bool = false
var search_timer: float = 0.0

func _ready() -> void:
	super._ready()
	add_to_group("Grunts")
	player = get_tree().get_first_node_in_group("Player")

	nav_agent.path_desired_distance = NAV_TOLERANCE
	nav_agent.target_desired_distance = NAV_TOLERANCE

	GameEvents.noise_emitted.connect(_on_noise_emitted)

	state = State.DORMANT if starts_dormant else State.PATROL
	if state == State.PATROL and not patrol_points.is_empty():
		call_deferred("_go_to_patrol_point")

func wake_up(target_pos: Vector3) -> void:
	if state != State.DORMANT:
		return
	wake_target_pos = target_pos
	state = State.ALERT
	nav_agent.target_position = target_pos

func take_damage(amount: int) -> void:
	super.take_damage(amount)
	if health > 0:
		_enter_combat(player.global_position if player else last_known_player_pos)

func _on_noise_emitted(pos: Vector3, radius: float) -> void:
	if state == State.COMBAT or state == State.DORMANT:
		return
	if global_position.distance_to(pos) <= radius:
		receive_alert(pos)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match state:
		State.DORMANT:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
		State.PATROL:
			_process_patrol(delta)
		State.ALERT:
			_process_alert(delta)
		State.COMBAT:
			_process_combat(delta)

	_check_vision()

	move_and_slide()

func _check_vision() -> void:
	can_see_player = false

	if not player:
		return

	var to_player: Vector3 = player.global_position - eyes.global_position
	var distance: float = to_player.length()
	if distance > vision_range:
		return

	if state != State.COMBAT:
		var facing: Vector3 = -global_transform.basis.z
		var angle: float = rad_to_deg(facing.angle_to(to_player.normalized()))
		if angle > vision_angle_deg / 2.0:
			return

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(eyes.global_position, player.global_position)
	query.exclude = get_self_exclude_list()
	var result: Dictionary = space_state.intersect_ray(query)

	if result.has("collider") and result["collider"] == player:
		can_see_player = true
		last_known_player_pos = player.global_position
		if state != State.COMBAT:
			_enter_combat(player.global_position)

func _enter_combat(pos: Vector3) -> void:
	if state == State.COMBAT:
		last_known_player_pos = pos
		return
	state = State.COMBAT
	last_known_player_pos = pos
	lost_sight_timer = 0.0
	searching = false
	search_timer = 0.0
	_alert_nearby_grunts(pos)

func _alert_nearby_grunts(pos: Vector3) -> void:
	for grunt in get_tree().get_nodes_in_group("Grunts"):
		if grunt == self:
			continue
		if grunt.state == State.DORMANT:
			continue
		if global_position.distance_to(grunt.global_position) <= alert_radius:
			if grunt.has_method("receive_alert"):
				grunt.receive_alert(pos)

func receive_alert(pos: Vector3) -> void:
	if state == State.COMBAT or state == State.DORMANT:
		return
	state = State.ALERT
	last_known_player_pos = pos
	nav_agent.target_position = pos

func _process_patrol(delta: float) -> void:
	if patrol_points.is_empty():
		return
	if nav_agent.is_navigation_finished():
		patrol_index = (patrol_index + 1) % patrol_points.size()
		_go_to_patrol_point()
	_move_along_path(move_speed * 0.5, delta)

func _process_alert(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		state = State.PATROL
		if not patrol_points.is_empty():
			_go_to_patrol_point()
		return
	_move_along_path(move_speed, delta)

func _process_combat(delta: float) -> void:
	if can_see_player:
		lost_sight_timer = 0.0
		searching = false
		nav_agent.target_position = last_known_player_pos
		_try_fire()
	else:
		lost_sight_timer += delta

		if lost_sight_timer >= LOSE_SIGHT_TIME:
			searching = true

		if searching:
			nav_agent.target_position = last_known_player_pos
			if nav_agent.is_navigation_finished():
				search_timer += delta
				if search_timer >= SEARCH_GIVEUP_TIME:
					state = State.PATROL
					searching = false
					search_timer = 0.0
					if not patrol_points.is_empty():
						_go_to_patrol_point()
					return
		else:
			nav_agent.target_position = last_known_player_pos

	_move_along_path(move_speed, delta)

func _go_to_patrol_point() -> void:
	if patrol_points.is_empty():
		return
	nav_agent.target_position = patrol_points[patrol_index].global_position

func _move_along_path(speed: float, delta: float) -> void:
	if nav_agent.is_navigation_finished():
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		return

	var next_pos: Vector3 = nav_agent.get_next_path_position()
	var dir: Vector3 = (next_pos - global_position)
	dir.y = 0

	var distance_to_target: float = global_position.distance_to(nav_agent.target_position)
	var speed_scale: float = clamp(distance_to_target / ARRIVAL_SLOWDOWN_RADIUS, 0.2, 1.0)
	var actual_speed: float = speed * speed_scale

	dir = dir.normalized()
	velocity.x = dir.x * actual_speed
	velocity.z = dir.z * actual_speed

	if dir.length() > 0.01:
		var target_transform: Transform3D = global_transform.looking_at(global_position + dir, Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_transform.basis, 1.0 - exp(-ROTATION_SPEED * delta))

func _try_fire() -> void:
	if not can_fire or not player:
		return

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(eyes.global_position, player.global_position)
	query.exclude = get_self_exclude_list()
	var result: Dictionary = space_state.intersect_ray(query)

	if result.has("collider") and result["collider"] == player and result["collider"].has_method("take_damage"):
		result["collider"].take_damage(damage)

	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
