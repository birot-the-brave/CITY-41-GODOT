extends Node3D
@export var weapon_holder: Node3D
var current_weapon: Node3D
signal weapon_equipped(weapon: Node3D)

func equip_weapon(id: String) -> void:
	if current_weapon:
		current_weapon.save_state()
		current_weapon.queue_free()

	var scene: PackedScene = WeaponDatabase.DATABASE[id].scene
	current_weapon = scene.instantiate()
	current_weapon.weapon_id = id
	current_weapon.set_stats(WeaponDatabase.DATABASE[id].stats)
	weapon_holder.add_child(current_weapon)
	load_weapon_state(id)

	PlayerData.equip(id)
	weapon_equipped.emit(current_weapon)

func load_weapon_state(id: String) -> void:
	var state: Dictionary = PlayerData.weapons["state"][id]
	current_weapon.magazine = state["magazine"]
	current_weapon.reserve = state["reserve"]

func equip_current() -> void:
	var id: String = PlayerData.weapons["equipped"]
	if id == "":
		return
	equip_weapon(id)
