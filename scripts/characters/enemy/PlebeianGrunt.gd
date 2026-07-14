extends GruntBase

func _ready() -> void:
	max_health = 40
	move_speed = 3.0
	vision_range = 15.0
	vision_angle_deg = 60.0
	fire_rate = 1.2
	damage = 8
	super._ready()
