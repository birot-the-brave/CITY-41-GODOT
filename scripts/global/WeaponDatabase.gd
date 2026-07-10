extends Node

var DATABASE: Dictionary = {
	"handgun": {
		"name": "Handgun",
		"scene": load("res://weapons/handgun/Handgun.tscn"),
		"icon": preload("res://weapons/handgun/HandgunIcon.png"),
		"stats": {
			"body_dmg": 12,
			"head_dmg": 30,
			"damage_variance": 2,
			"mag_size": 12,
			"reserves": 60
		}
	},

	"submachine": {
		"name": "SMG",
		"scene": load("res://weapons/submachine/SubmachineGun.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 12,
			"head_dmg": 30,
			"damage_variance": 1,
			"mag_size": 30,
			"reserves": 150
		}
	},

	"shotgun": {
		"name": "Shotgun",
		"scene": load("res://weapons/shotgun/Shotgun.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 8,
			"head_dmg": 20,
			"damage_variance": 1,
			"mag_size": 6,
			"reserves": 24,
			"pellet_count": 8,
			"spread_deg": 4.0
		}
	},

	"sniper": {
		"name": "Sniper Rifle",
		"scene": load("res://weapons/sniper/SniperRifle.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 70,
			"head_dmg": 150,
			"damage_variance": 3,
			"mag_size": 5,
			"reserves": 20
		}
	},

	"marksman_rifle": {
		"name": "Marksman Rifle",
		"scene": load("res://weapons/marksman/MarksmanRifle.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 45,
			"head_dmg": 90,
			"damage_variance": 3,
			"mag_size": 10,
			"reserves": 40
		}
	},

	"assault_rifle": {
		"name": "Assault Rifle",
		"scene": load("res://weapons/assault/AssaultRifle.tscn"),
		"icon": preload("res://weapons/assault/AssaultRifleIcon.png"),
		"stats": {
			"body_dmg": 20,
			"head_dmg": 45,
			"damage_variance": 2,
			"mag_size": 30,
			"reserves": 90
		}
	},

	"harpoon": {
		"name": "Harpoon Gun",
		"scene": load("res://weapons/harpoon/HarpoonGun.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 60,
			"head_dmg": 100,
			"damage_variance": 4,
			"mag_size": 1,
			"reserves": 5,
			"projectile_speed": 40.0
		}
	},

	"spear": {
		"name": "Spear Gun",
		"scene": load("res://weapons/spear/SpearGun.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 50,
			"head_dmg": 80,
			"damage_variance": 4,
			"mag_size": 1,
			"reserves": 3,
			"projectile_speed": 35.0
		}
	},

	"crossbow": {
		"name": "Crossbow",
		"scene": load("res://weapons/crossbow/Crossbow.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 55,
			"head_dmg": 110,
			"damage_variance": 3,
			"mag_size": 1,
			"reserves": 10,
			"projectile_speed": 60.0
		}
	},

	"compound": {
		"name": "Compound Bow",
		"scene": load("res://weapons/compound/CompoundBow.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 45,
			"head_dmg": 90,
			"damage_variance": 3,
			"mag_size": 1,
			"reserves": 15,
			"projectile_speed": 55.0
		}
	},

	"lightmachine": {
		"name": "LMG",
		"scene": load("res://weapons/lightmachine/LightMachineGun.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 22,
			"head_dmg": 50,
			"damage_variance": 2,
			"mag_size": 75,
			"reserves": 150
		}
	},

	"grenade_launcher": {
		"name": "Grenade Launcher",
		"scene": load("res://weapons/grenadelauncher/GrenadeLauncher.tscn"),
		"icon": null,
		"stats": {
			"body_dmg": 100,
			"head_dmg": 100,
			"damage_variance": 5,
			"mag_size": 1,
			"reserves": 6,
			"projectile_speed": 25.0,
			"splash_radius": 4.0
		}
	}
}
