class_name Data
extends Resource

# im not gonna finish this i dont have the time rn bruhhh whatever
# https://youtu.be/YuMfFIKLAgs
# heres the tutorial, timestamp = 15:00

@export
var save_name : String = "New Save"
@export
var save_path : String = "user://saves/save0"

func _init(
		_save_name : String = "New Save",
		_save_path : String = "user://saves/save0"
) -> void:
	save_name = _save_name
	save_path = _save_path
