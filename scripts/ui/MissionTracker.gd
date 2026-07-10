extends Control

@onready var label: Label = $Label

func _ready() -> void:
	MissionManager.mission_started.connect(_refresh)
	MissionManager.mission_progress_changed.connect(_refresh)
	MissionManager.mission_completed.connect(_on_mission_completed)
	hide()
	_refresh()

func _refresh(_id: int = -1) -> void:
	var id: int = MissionManager.get_active_mission_id()
	if id == -1:
		hide()
		return

	var def: Dictionary = MissionDatabase.MISSIONS[id]
	var progress: Dictionary = MissionManager.get_progress(id)

	if def["linear"]:
		var next_obj: Dictionary = MissionManager.get_next_objective(id)
		label.text = "%s\n> %s" % [def["name"], next_obj.get("label", "")]
	else:
		var lines: Array[String] = [def["name"]]
		for obj in def["objectives"]:
			var mark: String = "[x]" if progress.get(obj["id"], false) else "[ ]"
			lines.append("%s %s" % [mark, obj["label"]])
		label.text = "\n".join(lines)

	show()

func _on_mission_completed(_id: int) -> void:
	hide()
