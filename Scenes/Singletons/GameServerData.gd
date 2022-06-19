extends Node
class_name GameServerData

onready var player_verification_process = get_node("/root/Main/PlayerVerification")

onready var skill_data = LoadData("SkillData")
onready var stats_data = LoadData("StatsData")

var expected_tokens = []

func LoadData(data_name):
	return LoadDataFromJSON(data_name)


func LoadDataFromJSON(path):
	var data_file = File.new()
	data_file.open("res://Data/"+path+".json", File.READ)
	var data_json = JSON.parse(data_file.get_as_text())
	data_file.close()
	return data_json.result
