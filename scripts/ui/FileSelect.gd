extends Control

signal back_pressed(origin: String)
signal new_pressed(origin: String)
signal load_pressed(origin: String)
signal delete_pressed(origin: String)

func _on_back_pressed() -> void:
	back_pressed.emit("file_select")


func _on_new_file_pressed() -> void:
	new_pressed.emit("file_select")


func _on_load_file_pressed() -> void:
	load_pressed.emit("file_select")


func _on_delete_file_pressed() -> void:
	delete_pressed.emit("file_select")
