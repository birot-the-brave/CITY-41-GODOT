extends Node

signal mission_started(id: int)
signal objective_completed(id: int, objective: String)
signal mission_completed(id: int)
signal mission_progress_changed(id: int)

func start_mission(id: int) -> void:
	var id_str: String = str(id)

	if PlayerData.missions_data["completed"].has(id):
		return
	if PlayerData.missions_data["active"].has(id_str):
		return
	if not MissionDatabase.MISSIONS.has(id):
		push_error("No mission registered with id: ", id)
		return

	var def: Dictionary = MissionDatabase.MISSIONS[id]
	var progress: Dictionary = {}
	for obj in def["objectives"]:
		progress[obj["id"]] = false

	PlayerData.missions_data["active"][id_str] = progress
	mission_started.emit(id)

func complete_objective(id: int, objective: String) -> void:
	var id_str: String = str(id)
	if not PlayerData.missions_data["active"].has(id_str):
		return

	var progress: Dictionary = PlayerData.missions_data["active"][id_str]
	if not progress.has(objective) or progress[objective]:
		return

	var def: Dictionary = MissionDatabase.MISSIONS[id]
	if def["linear"]:
		var next_obj: Dictionary = get_next_objective(id)
		if next_obj.get("id", "") != objective:
			return

	progress[objective] = true
	objective_completed.emit(id, objective)
	mission_progress_changed.emit(id)

	var obj_def: Dictionary = _get_objective_def(id, objective)
	if obj_def.get("autosave", false):
		_autosave()

	_check_complete(id)

func _check_complete(id: int) -> void:
	var id_str: String = str(id)
	var progress: Dictionary = PlayerData.missions_data["active"][id_str]

	for done in progress.values():
		if not done:
			return

	PlayerData.missions_data["active"].erase(id_str)
	PlayerData.missions_data["completed"].append(id)
	PlayerData.missions += 1
	mission_completed.emit(id)

	if MissionDatabase.MISSIONS[id].get("autosave_on_complete", false):
		_autosave()

func _get_objective_def(id: int, objective_id: String) -> Dictionary:
	for obj in MissionDatabase.MISSIONS[id]["objectives"]:
		if obj["id"] == objective_id:
			return obj
	return {}

func _autosave() -> void:
	PlayerData.save_player_data(PlayerData.current_slot)
	print("autosaved")

func trigger_checkpoint() -> void:
	_autosave()

func is_mission_active(id: int) -> bool:
	return PlayerData.missions_data["active"].has(str(id))

func is_mission_completed(id: int) -> bool:
	return PlayerData.missions_data["completed"].has(id)

func get_progress(id: int) -> Dictionary:
	return PlayerData.missions_data["active"].get(str(id), {})

func get_objective_label(id: int, objective_id: String) -> String:
	for obj in MissionDatabase.MISSIONS[id]["objectives"]:
		if obj["id"] == objective_id:
			return obj["label"]
	return objective_id

func get_next_objective(id: int) -> Dictionary:
	var progress: Dictionary = get_progress(id)
	for obj in MissionDatabase.MISSIONS[id]["objectives"]:
		if not progress.get(obj["id"], false):
			return obj
	return {}

func get_active_mission_id() -> int:
	var active: Dictionary = PlayerData.missions_data["active"]
	if active.is_empty():
		return -1
	return int(active.keys()[0])
