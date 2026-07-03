extends Control

signal file_select_pressed(origin: String)
signal quit_pressed(origin: String)


func _on_file_select_pressed() -> void:
	file_select_pressed.emit("main_menu")


func _on_quit_pressed() -> void:
	quit_pressed.emit("main_menu")
