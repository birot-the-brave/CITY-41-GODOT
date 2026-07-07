extends Control  # change to CanvasLayer/Node if that's what HUD actually is

@onready var health_label: Label = $HealthLabel
@onready var ammo_label: Label = $AmmoLabel

var current_weapon_ref: Node3D

func _ready() -> void:
	PlayerData.health_changed.connect(_on_health_changed)
	_on_health_changed(PlayerData.health)
	ammo_label.text = ""

func _on_health_changed(value: int) -> void:
	health_label.text = "HP: %d" % value

func connect_weapon_manager(weapon_manager: Node3D) -> void:
	weapon_manager.weapon_equipped.connect(_on_weapon_equipped)

func _on_weapon_equipped(weapon: Node3D) -> void:
	if current_weapon_ref and current_weapon_ref.ammo_changed.is_connected(_on_ammo_changed):
		current_weapon_ref.ammo_changed.disconnect(_on_ammo_changed)

	current_weapon_ref = weapon
	current_weapon_ref.ammo_changed.connect(_on_ammo_changed)
	_on_ammo_changed(weapon.magazine, weapon.reserve)

func _on_ammo_changed(magazine: int, reserve: int) -> void:
	ammo_label.text = "%d / %d" % [magazine, reserve]
