extends Node3D
@export var weapon_id: String
signal ammo_changed(magazine: int, reserve: int)

var magazine
var reserve

func save_state() -> void:
	PlayerData.weapons["state"][weapon_id]["magazine"] = magazine
	PlayerData.weapons["state"][weapon_id]["reserve"] = reserve
	ammo_changed.emit(magazine, reserve)
