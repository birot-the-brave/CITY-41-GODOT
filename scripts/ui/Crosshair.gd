extends Control

@export var crosshair_size: float = 8.0
@export var thickness: float = 2.0
@export var gap: float = 4.0
@export var color: Color = Color.WHITE

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)

func _draw() -> void:
	var center: Vector2 = size_of_viewport() / 2.0

	# top
	draw_line(center + Vector2(0, -gap - crosshair_size), center + Vector2(0, -gap), color, thickness)
	# bottom
	draw_line(center + Vector2(0, gap), center + Vector2(0, gap + crosshair_size), color, thickness)
	# left
	draw_line(center + Vector2(-gap - crosshair_size, 0), center + Vector2(-gap, 0), color, thickness)
	# right
	draw_line(center + Vector2(gap, 0), center + Vector2(gap + crosshair_size, 0), color, thickness)

func size_of_viewport() -> Vector2:
	return get_viewport_rect().size
