class_name DroppedQuestPool
extends BaseQuestPool


func drop_quest(quest_id: int) -> void:
	var quest := get_quest_from_id(quest_id)
	if quest == null:
		return
	quest.drop()
