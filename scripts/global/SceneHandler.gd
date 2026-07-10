extends Node
@export var main_menu_packed: PackedScene
@export var file_select_packed: PackedScene
@export var game_scene_packed: PackedScene
@export var pause_menu_packed: PackedScene

func _ready() -> void:
	load_main_menu("game_start")
	GameEvents.pause_requested.connect(_on_pause_requested)

func _on_pause_requested() -> void:
	if get_tree().paused:
		return
	open_pause_menu()

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
	file_select.back_pressed.connect(load_main_menu.bind("file_select"))
	file_select.new_pressed.connect(new_save)
	file_select.load_pressed.connect(load_save)
	file_select.delete_pressed.connect(delete_save)
	add_child(file_select)

func open_pause_menu() -> void:
	get_tree().paused = true
	var pause_menu: Control = pause_menu_packed.instantiate()
	pause_menu.name = "PauseMenu"
	pause_menu.resume_pressed.connect(close_pause_menu)
	pause_menu.save_and_quit_pressed.connect(_on_pause_save_and_quit)
	pause_menu.quit_without_saving_pressed.connect(_on_pause_quit_without_saving)
	add_child(pause_menu)

func close_pause_menu() -> void:
	get_tree().paused = false
	if has_node("PauseMenu"):
		get_node("PauseMenu").queue_free()
	GameEvents.game_resumed.emit()

func _on_pause_save_and_quit() -> void:
	PlayerData.save_player_data(PlayerData.current_slot)
	_exit_to_main_menu()

func _on_pause_quit_without_saving() -> void:
	_exit_to_main_menu()

func _exit_to_main_menu() -> void:
	get_tree().paused = false
	if has_node("PauseMenu"):
		get_node("PauseMenu").queue_free()
	if has_node("GameScene"):
		get_node("GameScene").queue_free()
	load_main_menu("pause_menu")

func new_save(slot: int) -> void:
	PlayerData.health = 100
	PlayerData.missions = 0
	PlayerData.position = Vector3.ZERO
	PlayerData.current_slot = slot
	#PlayerData.save_player_data(slot)
	MissionManager.start_mission(00)

	_start_game()

func load_save(slot: int) -> void:
	PlayerData.load_player_data(slot)
	_start_game()

func delete_save(slot: int) -> void:
	PlayerData.delete_save(slot)

func _start_game() -> void:
	get_node("FileSelect").queue_free()
	var game_scene: Node = game_scene_packed.instantiate()
	game_scene.name = "GameScene"
	add_child(game_scene)

func settings_open(_origin: String) -> void:
	pass

func exit_game(_origin: String) -> void:
	get_tree().quit()
