class_name ActiveQuestPoolOverride
extends ActiveQuestPool

func add_quest(quest: Quest) -> Quest:
	if QuestSystem.is_quest_in_pool(quest, "Dropped"):
		print("Quest is already complete, skipping.")
		return quest
	super(quest)
	return
