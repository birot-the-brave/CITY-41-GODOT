extends Node3D

var current_weapon

func equip_weapon(id):
	if current_weapon:
		current_weapon.queue_free()
	var scene = WeaponDatabase.DATABASE[id].scene
	current_weapon = scene.instantiate()
	weapon_holder.add_child(current_weapon)
	#chatgpt on ur phone has the rest of the stuff, 90% sure that
	#this is meant to go in playerdata or the normal player_chr script lol
