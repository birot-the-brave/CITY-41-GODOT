extends Control

var slot_nodes: Array[TextureRect] = []
var selected_index: int = -1

@onready var slot_container: Control = $SlotContainer 

func _ready() -> void:
	hide()

func open() -> void:
	_build_slots()
	selected_index = -1
	show()

func close() -> void:
	hide()

func get_selected_id() -> String:
	var order: Array = PlayerData.weapons["wheel_order"]
	if selected_index == -1 or selected_index >= order.size():
		return ""
	return order[selected_index]

func _build_slots() -> void:
	for child in slot_container.get_children():
		child.queue_free()
	slot_nodes.clear()

	var order: Array = PlayerData.weapons["wheel_order"]
	var count: int = order.size()
	if count == 0:
		return
	
	var radius: float = 150.0
	var center: Vector2 = size / 2.0

	for i in range(count):
		var id: String = order[i]
		var angle: float = (TAU / count) * i - PI / 2.0
		var pos: Vector2 = center + Vector2(cos(angle), sin(angle)) * radius

		var icon := TextureRect.new()
		icon.texture = WeaponDatabase.DATABASE[id].icon
		icon.custom_minimum_size = Vector2(64, 64)
		icon.position = pos - icon.custom_minimum_size / 2.0
		slot_container.add_child(icon)
		slot_nodes.append(icon)

func _process(_delta: float) -> void:
	if not visible:
		return
	_update_selection()

func _update_selection() -> void:
	var order: Array = PlayerData.weapons["wheel_order"]
	var count: int = order.size()
	if count == 0:
		return

	var center: Vector2 = size / 2.0
	var dir: Vector2 = get_local_mouse_position() - center

	if dir.length() < 20.0:
		selected_index = -1
		_update_highlight()
		return

	var angle: float = dir.angle() + PI / 2.0
	if angle < 0:
		angle += TAU

	var slice: float = TAU / count
	var index: int = int(round(angle / slice)) % count

	if index != selected_index:
		selected_index = index
		_update_highlight()

func _update_highlight() -> void:
	for i in range(slot_nodes.size()):
		slot_nodes[i].modulate = Color.WHITE if i == selected_index else Color(0.6, 0.6, 0.6)
