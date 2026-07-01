# https://youtu.be/wN2DPKzMikk?t=1412 timestamped to where i've made it to.
# he is about to test the save function in his main menu which seems to have a tutorial
# that is also on his page, so i will do that before continuing the save system !
# this is looking pretty cool so far i just need to remember to make it so the game will
# likely use a checkpoint system during the missions at the least.

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
	pass

func load_player_data_bin() -> void:
	pass

func verify_save_data_json(save_data: Dictionary) -> Error:
	

func verify_save_data_bin(save_data: Dictionary) -> Error:
	
