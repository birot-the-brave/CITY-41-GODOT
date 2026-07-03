extends Node

@export var main_menu_packed: PackedScene
@export var file_select_packed: PackedScene
@export var game_scene_packed: PackedScene
@export var pause_menu_packed: PackedScene

func _ready() -> void:
	load_main_menu("game_start")



func load_main_menu(origin: String) -> void:
	if origin == "file_select":
		get_node("FileSelect").queue_free()
	if origin == "pause_menu":
		get_node("PauseMenu").queue_free()
		
	var main_menu: Control = main_menu_packed.instantiate()
	main_menu.file_select_pressed.connect(file_select)
	main_menu.quit_pressed.connect(exit_game)
	add_child(main_menu)

func file_select(origin: String) -> void:
	if origin == "main_menu":
		get_node("MainMenu").queue_free()
	var file_select: Control = file_select_packed.instantiate()
	file_select.back_pressed.connect(load_main_menu)
	file_select.new_pressed.connect(new_save)
	file_select.load_pressed.connect(load_save)
	file_select.delete_pressed.connect(delete_save)
	add_child(file_select)

func pause_menu(origin: String) -> void:
	var pause_menu: Control = pause_menu_packed.instantiate()
	pause_menu.save_quit_pressed.connect(load_main_menu)

func new_save(origin: String) -> void:
	
	pass

func load_save(origin: String) -> void:
	
	pass

func delete_save(origin: String) -> void:
	
	pass

func settings_open(_origin: String) -> void:
	
	pass

func exit_game(_origin: String):
	get_tree().quit()
