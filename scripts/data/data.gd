extends Resource
class_name Data


@export var save_name : String = "New Save"
@export var save_path : String = "user://saves/save0"

func _init(
		_save_name : String = "New Save",
		_save_path : String = "user://saves/save0"
) -> void:
	save_name = _save_name
	save_path = _save_path
  
