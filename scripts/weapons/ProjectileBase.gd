class_name Projectile
extends RigidBody3D

var damage: int = 0
var head_damage: int = 0
var splash_radius: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func launch(direction: Vector3, speed: float) -> void:
	linear_velocity = direction * speed

func _on_body_entered(body: Node) -> void:
	if splash_radius > 0.0:
		_apply_splash_damage()
	else:
		_apply_direct_damage(body)
	queue_free()

func _apply_direct_damage(body: Node) -> void:
	if not body.has_method("take_damage"):
		return
	var is_head: bool = body is StaticBody3D and body.get("is_head") == true
	body.take_damage(head_damage if is_head else damage)

func _apply_splash_damage() -> void:
	var space_state := get_world_3d().direct_space_state
	var shape := SphereShape3D.new()
	shape.radius = splash_radius

	var params := PhysicsShapeQueryParameters3D.new()
	params.shape = shape
	params.transform = global_transform
	params.collide_with_bodies = true

	var results: Array[Dictionary] = space_state.intersect_shape(params, 32)
	for result in results:
		var body: Object = result["collider"]
		if body.has_method("take_damage"):
			body.take_damage(damage)
