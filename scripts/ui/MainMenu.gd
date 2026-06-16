extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_file_select_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/FileSelect.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
