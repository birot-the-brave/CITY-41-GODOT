class_name TargetDummy
extends Node3D

@export var max_health: int = 50
@export var mission_id: int = -1       # -1 = not tied to a mission
@export var objective_id: String = ""  # leave blank if this dummy doesn't complete anything alone
@export var group_objective_id: String = ""  # for "kill all dummies in this group" objectives

var health: int

signal died

func _ready() -> void:
	health = max_health
	add_to_group("clear_group_%s" % group_objective_id) if group_objective_id != "" else null

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)
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
