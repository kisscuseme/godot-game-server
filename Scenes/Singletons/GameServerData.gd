extends Node
class_name GameServerData

onready var skill_data = LoadData("SkillData")
onready var stats_data = LoadData("StatsData")


func LoadData(data_name):
	return GlobalData.LoadDataFromJSON(data_name)
