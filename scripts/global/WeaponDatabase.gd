extends Node

var DATABASE: Dictionary = {
	"handgun": {
		"name": "Handgun",
		"scene": load("res://weapons/handgun/Handgun.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": 34,
			"head_dmg": 56,
			"mag_size": 12,
			"reserves": 60
		}
	},
	"submachine": {
		"name": "Submachine Gun",
		"scene": load("res://weapons/submachine/SubmachineGun.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"shotgun": {
		"name": "Shotgun",
		"scene": load("res://weapons/shotgun/Shotgun.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"sniper": {
		"name": "Sniper Rifle",
		"scene": load("res://weapons/sniper/SniperRifle.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"marksman_rifle": {
		"name": "Marksman Rifle",
		"scene": load("res://weapons/marksman/MarksmanRifle.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"assualt_rifle": {
		"name": "Assault Rifle",
		"scene": load("res://weapons/assault/AssaultRifle.tscn"),
		"icon": preload("res://weapons/assault/AssaultRifleIcon.png"),
		"stats": {
			"body_dmg": 15,
			"head_dmg": 34,
			"mag_size": 30,
			"reserves": 180
		}
	},
	"harpoon": {
		"name": "Harpoon Gun",
		"scene": load("res://weapons/harpoon/HarpoonGun.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"spear": {
		"name": "Spear Gun",
		"scene": load("res://weapons/spear/SpearGun.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"crossbow": {
		"name": "Crossbow",
		"scene": load("res://weapons/crossbow/Crossbow.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"compound": {
		"name": "Compound Bow",
		"scene": load("res://weapons/compound/CompoundBow.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"lightmachine": {
		"name": "Light Machine Gun",
		"scene": load("res://weapons/lightmachine/LightMachineGun.gd.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
	"grenade_launcher": {
		"name": "Grenade Launcher",
		"scene": load("res://weapons/grenadelauncher/GrenadeLauncher.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": "",
			"head_dmg": "",
			"mag_size": "",
			"reserves": ""
		}
	},
}
