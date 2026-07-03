extends Resource
class_name PlayerData

@export var health := 100

@export var SavePos : Vector3

func change_health(value : int):
	health += value

func UpdatePos(value : Vector3):
	SavePos = value
