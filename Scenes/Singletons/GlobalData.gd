extends Node

onready var player_verification_process = get_node("/root/GameServer/PlayerVerification")

var expected_tokens = []
var player_state_collection = {}

var skip_auth = false

var server_info = LoadDataFromJSON("GlobalData")

func LoadDataFromJSON(path):
	var data_file = File.new()
	data_file.open("res://Data/"+path+".json", File.READ)
	var data_json = JSON.parse(data_file.get_as_text())
	data_file.close()
	return data_json.result
