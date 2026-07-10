extends Control

@onready var label: Label = $Label

var message_queue: Array[String] = []
var showing: bool = false

func _ready() -> void:
	modulate.a = 0.0
	MissionManager.objective_completed.connect(_on_objective_completed)
	MissionManager.mission_completed.connect(_on_mission_completed)

func _on_objective_completed(id: int, objective: String) -> void:
	var mission_name: String = MissionDatabase.MISSIONS[id]["name"]
	var label_text: String = MissionManager.get_objective_label(id, objective)
	_queue_message("%s\n%s complete" % [mission_name, label_text])

func _on_mission_completed(id: int) -> void:
	var mission_name: String = MissionDatabase.MISSIONS[id]["name"]
	_queue_message("Mission Complete: %s" % mission_name)

func _queue_message(text: String) -> void:
	message_queue.append(text)
	if not showing:
		_show_next()

func _show_next() -> void:
	if message_queue.is_empty():
		showing = false
		return

	showing = true
	label.text = message_queue.pop_front()

	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_interval(1.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(_show_next)
