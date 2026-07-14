class_name EnemyBase
extends CharacterBody3D

@export var max_health: int = 50
@export var mission_id: int = -1
@export var objective_id: String = ""
@export var group_objective_id: String = ""

var health: int

signal died
signal damaged(amount: int)

@onready var body_hitbox: StaticBody3D = $BodyHitbox
@onready var head_hitbox: StaticBody3D = $HeadHitbox

func _ready() -> void:
	health = max_health
	if group_objective_id != "":
		add_to_group("clear_group_%s" % group_objective_id)

	add_collision_exception_with(body_hitbox)
	add_collision_exception_with(head_hitbox)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)
	damaged.emit(amount)
	if health <= 0:
		die()

func die() -> void:
	died.emit()

	if mission_id != -1 and MissionManager.is_mission_active(mission_id):
		if objective_id != "":
			MissionManager.complete_objective(mission_id, objective_id)

		if group_objective_id != "":
			remove_from_group("clear_group_%s" % group_objective_id)
			var remaining: int = get_tree().get_nodes_in_group("clear_group_%s" % group_objective_id).size()
			if remaining == 0:
				MissionManager.complete_objective(mission_id, group_objective_id)

	queue_free()

func get_self_exclude_list() -> Array:
	return [self, body_hitbox, head_hitbox]
