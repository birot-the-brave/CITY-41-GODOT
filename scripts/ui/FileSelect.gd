extends Control

signal back_pressed
signal new_pressed(slot: int)
signal load_pressed(slot: int)
signal delete_pressed(slot: int)

var selected_slot = -1

@onready var slot_buttons: Array[Button] = [
	$MarginContainer/VBoxContainer/SaveSlots/SaveSlotMargin/SaveSlotContainer/SaveSlot1,
	$MarginContainer/VBoxContainer/SaveSlots/SaveSlotMargin/SaveSlotContainer/SaveSlot2,
	$MarginContainer/VBoxContainer/SaveSlots/SaveSlotMargin/SaveSlotContainer/SaveSlot3,
	$MarginContainer/VBoxContainer/SaveSlots/SaveSlotMargin/SaveSlotContainer/SaveSlot4,
	$MarginContainer/VBoxContainer/SaveSlots/SaveSlotMargin/SaveSlotContainer/SaveSlot5,
]

@onready var back_button: Button = $MarginContainer/VBoxContainer/Back
@onready var new_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/NewFile
@onready var load_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/LoadFile
@onready var delete_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/DeleteFile

func _ready() -> void:
	for i in range(slot_buttons.size()):
		slot_buttons[i].pressed.connect(_on_slot_pressed.bind(i))
	
	back_button.pressed.connect(func(): back_pressed.emit())
	new_button.pressed.connect(_on_new_file_pressed)
	load_button.pressed.connect(_on_load_file_pressed)
	delete_button.pressed.connect(_on_delete_file_pressed)
	
	_refresh_slot_display()
	_update_action_buttons()

func _on_slot_pressed(slot: int) -> void:
	selected_slot = slot
	_update_selection_highlight()
	_update_action_buttons()

func _update_selection_highlight() -> void:
	for i in range(slot_buttons.size()):
		slot_buttons[i].modulate = Color.WHITE if i == selected_slot else Color(0.6, 0.6, 0.6)

func _update_action_buttons() -> void:
	var has_selection: bool = selected_slot != -1
	var slot_has_save: bool = has_selection and PlayerData.save_exists(selected_slot)
	new_button.disabled = not has_selection
	load_button.disabled = not slot_has_save
	delete_button.disabled = not slot_has_save

func _refresh_slot_display() -> void:
	for i in range(slot_buttons.size()):
		slot_buttons[i].text = "Slot %d\n(Saved)" % (i + 1) if PlayerData.save_exists(i) else "Slot %d\n(Empty)" % (i + 1)

func _on_new_file_pressed() -> void:
	if selected_slot == -1:
		return
	new_pressed.emit(selected_slot)


func _on_load_file_pressed() -> void:
	if selected_slot == -1 or not PlayerData.save_exists(selected_slot):
		return
	load_pressed.emit(selected_slot)


func _on_delete_file_pressed() -> void:
	if selected_slot == -1:
		return
	delete_pressed.emit(selected_slot)
	_refresh_slot_display()
	_update_action_buttons()
