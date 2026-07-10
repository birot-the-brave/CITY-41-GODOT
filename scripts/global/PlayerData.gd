extends Node

signal health_changed(value: int)

const KEY_HEALTH: String = "health"
const KEY_MISSIONS: String = "missions"
const KEY_WEAPONS: String = "weapons"
const KEY_POS_X: String = "pos_x"
const KEY_POS_Y: String = "pos_y"
const KEY_POS_Z: String = "pos_z"
const SAVE_DIR: String = "user://save_files/"
const KEY_MISSIONS_DATA: String = "missions_data"

var current_slot: int = 0

# player variables
var health: int = 100:
	set(value):
		health = clamp(value, 0, 100)
		health_changed.emit(health)
	get:
		return health
var missions: int = 0
var position: Vector3 = Vector3.ZERO
var weapons: Dictionary = {
	"owned": [],
	"equipped": "",
	"wheel_order": [],
	"state": {}
}
var missions_data: Dictionary = {
	"active": {},
	"completed": []
}

func unlock_weapon(id: String) -> void:
	if weapons["owned"].has(id):
		return
	weapons["owned"].append(id)
	weapons["wheel_order"].append(id)  # auto-add to end of wheel; player can reorder later

	var db: Dictionary = WeaponDatabase.DATABASE[id]
	weapons["state"][id] = {
		"magazine": db.stats.mag_size,
		"reserve": db.stats.reserves,
	}

func owns_weapon(id: String) -> bool:
	return weapons["owned"].has(id)

func set_wheel_order(order: Array) -> void:
	weapons["wheel_order"] = order

func equip(id: String) -> void:
	if not owns_weapon(id):
		return
	weapons["equipped"] = id

func get_save_path(slot: int) -> String:
	return SAVE_DIR + "slot_%d.json" % slot

func save_player_data(slot: int) -> void:
	var save_data: Dictionary = {
		KEY_HEALTH: health,
		KEY_MISSIONS: missions,
		KEY_POS_X: position.x,
		KEY_POS_Y: position.y,
		KEY_POS_Z: position.z,
		KEY_WEAPONS: weapons,
		KEY_MISSIONS_DATA: missions_data,
	}
	var err: Error = FileHandler.store_json_file(save_data, get_save_path(slot), true)
	if err != OK:
		push_error("Could not save player data: ", error_string(err))

func load_player_data(slot: int) -> void:
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_json_file(get_save_path(slot), save_data)
	if err != OK:
		push_error("Could not load player data: ", error_string(err))
		return
	err = verify_save_data(save_data)
	if err != OK:
		push_error("Invalid save file structure")
		return
	health = save_data[KEY_HEALTH]
	missions = save_data[KEY_MISSIONS]
	position = Vector3(save_data[KEY_POS_X], save_data[KEY_POS_Y], save_data[KEY_POS_Z])
	weapons = save_data.get(KEY_WEAPONS, {"owned": [], "equipped": "", "wheel_order": [], "state": {}})
	missions_data = save_data.get(KEY_MISSIONS_DATA, {"active": {}, "completed": []})
	current_slot = slot

func verify_save_data(save_data: Dictionary) -> Error:
	if not save_data.has(KEY_HEALTH):
		return ERR_DOES_NOT_EXIST
	if not save_data.has(KEY_MISSIONS):
		return ERR_DOES_NOT_EXIST
	if not save_data.has(KEY_POS_X) or not save_data.has(KEY_POS_Y) or not save_data.has(KEY_POS_Z):
		return ERR_DOES_NOT_EXIST
	return OK

func delete_save(slot: int) -> void:
	var path: String = get_save_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(get_save_path(slot))
