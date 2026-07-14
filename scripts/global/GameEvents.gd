extends Node

signal pause_requested
signal game_resumed
signal nav_rebake_requested(region: NavigationRegion3D)
signal noise_emitted(position: Vector3, radius: float)

func _ready() -> void:
	nav_rebake_requested.connect(_on_nav_rebake_requested)

func _on_nav_rebake_requested(region: NavigationRegion3D) -> void:
	if not region:
		return
	await get_tree().physics_frame
	await get_tree().physics_frame
	region.bake_navigation_mesh()
