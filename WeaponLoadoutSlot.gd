extends TextureRect

signal reordered(from_index: int, to_index: int)

var weapon_id: String
var slot_index: int

func set_weapon(id: String, index: int) -> void:
	weapon_id = id
	slot_index = index
	texture = WeaponDatabase.DATABASE[id].icon
	custom_minimum_size = Vector2(64, 64)

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := TextureRect.new()
	preview.texture = texture
	preview.custom_minimum_size = Vector2(64, 64)
	set_drag_preview(preview)
	return slot_index

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_INT

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	reordered.emit(data, slot_index)
