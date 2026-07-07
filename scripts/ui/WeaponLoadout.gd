extends Control

@onready var slot_container: HBoxContainer = $SlotContainer  # adjust path
const SLOT_SCENE := preload("res://scenes/ui/WeaponLoadoutSlot.tscn")  # see below

func refresh() -> void:
	for child in slot_container.get_children():
		child.queue_free()

	var order: Array = PlayerData.weapons["wheel_order"]
	if order.is_empty():
		var label := Label.new()
		label.text = "No weapons unlocked yet."
		slot_container.add_child(label)
		return

	for i in range(order.size()):
		var slot: Control = SLOT_SCENE.instantiate()
		slot.set_weapon(order[i], i)
		slot.reordered.connect(_on_slot_reordered)
		slot_container.add_child(slot)
func _on_slot_reordered(from_index: int, to_index: int) -> void:
	var order: Array = PlayerData.weapons["wheel_order"]
	var id: String = order.pop_at(from_index)
	order.insert(to_index, id)
	PlayerData.set_wheel_order(order)
	refresh()
