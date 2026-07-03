extends Control

signal resume_pressed
signal save_and_quit_pressed
signal quit_without_saving_pressed

@onready var main_panel: Control = $MainPausePanel
@onready var quit_confirm_panel: Control = $QuitConfirmPanel

@onready var resume_button: Button = $MainPausePanel/VBoxContainer/Resume
@onready var quit_button: Button = $MainPausePanel/VBoxContainer/Quit

@onready var save_and_exit_button: Button = $QuitConfirmPanel/VBoxContainer/QuitHbox/SaveAndExit
@onready var exit_without_saving_button: Button = $QuitConfirmPanel/VBoxContainer/QuitHbox/ExitWithoutSaving
@onready var cancel_button: Button = $QuitConfirmPanel/VBoxContainer/Cancel

func _ready() -> void:
	quit_confirm_panel.hide()

	resume_button.pressed.connect(func(): resume_pressed.emit())
	quit_button.pressed.connect(_show_quit_confirm)

	save_and_exit_button.pressed.connect(func(): save_and_quit_pressed.emit())
	exit_without_saving_button.pressed.connect(func(): quit_without_saving_pressed.emit())
	cancel_button.pressed.connect(_hide_quit_confirm)

func _show_quit_confirm() -> void:
	main_panel.hide()
	quit_confirm_panel.show()

func _hide_quit_confirm() -> void:
	quit_confirm_panel.hide()
	main_panel.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if quit_confirm_panel.visible:
			_hide_quit_confirm()
		else:
			resume_pressed.emit()
		get_viewport().set_input_as_handled()
