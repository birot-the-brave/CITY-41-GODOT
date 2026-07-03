# https://youtu.be/wN2DPKzMikk?t=1672 new timestamp

extends Node

const KEY_HEALTH: String = "health"
const KEY_MISSIONS: String = "missions"

# save paths
var save_path_json: String = "user://save_files/savegame.json"
var save_path_bin: String = "user://save_files/savegame.save"

# player variables
var health: int = 100
var missions: int = 0

func save_player_data_json() -> void:
	var save_data: Dictionary = {
		KEY_HEALTH: health,
		KEY_MISSIONS: missions
	}
	var err: Error = FileHandler.store_json_file(save_data, save_path_json, true)
	if err != OK:
		push_error("Could not save player data (JSON): ", error_string(err))

func save_player_data_bin() -> void:
	var save_data: Dictionary = {
		KEY_HEALTH: health,
		KEY_MISSIONS: missions
	}
	var err: Error = FileHandler.store_binary_file(save_data, save_path_bin, true)
	if err != OK:
		push_error("Could not save player data (binary): ", error_string(err))

func load_player_data_json() -> void:
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_json_file(save_path_json, save_data)
	if err != OK:
		push_error("Could not load player data (JSON): ", error_string(err))
		return
		
	err = verify_save_data_json(save_data)
	if err != OK:
		push_error("Invalid save file structure")
		return
		
	health = save_data[KEY_HEALTH]
	missions = save_data[KEY_MISSIONS]

func load_player_data_bin() -> void:
	var save_data: Dictionary = {}
	var err: Error = FileHandler.open_bin_file(save_path_json, save_data)
	if err != OK:
		push_error("Could not load player data (binary): ", error_string(err))
		return
		
	err = verify_save_data_bin(save_data)
	if err != OK:
		push_error("Invalid save file structure")
		return
		
	health = save_data[KEY_HEALTH]
	missions = save_data[KEY_MISSIONS]

func verify_save_data_json(save_data: Dictionary) -> Error:
	if not save_data.has(KEY_HEALTH):
		return ERR_DOES_NOT_EXIST
	if not save_data.has(KEY_MISSIONS):
		return ERR_DOES_NOT_EXIST
	return OK

func verify_save_data_bin(save_data: Dictionary) -> Error:
	if not save_data.has(KEY_HEALTH):
		return ERR_DOES_NOT_EXIST
	if not save_data.has(KEY_MISSIONS):
		return ERR_DOES_NOT_EXIST
	return OK
