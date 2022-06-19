extends GameServerData
class_name GameServerMethods

remote func FetchAction(action_name, value_name, requester = null):
	var player_id = get_tree().get_rpc_sender_id()
	var return_value
	match action_name:
		"skill_damage":
			return_value = GetSkillDamage(value_name, player_id)
		"get_data":
			match value_name:
				"Player Stats":
					return_value = GetStats(player_id)
				_:
					return_value = ""
		_:
			return_value = ""
	rpc_id(player_id, "ReturnAction", action_name, value_name, return_value, requester)
	print("sending " + str(return_value) + " to player")


func GetSkillDamage(skill_name, player_id):
	var damage = skill_data[skill_name].Damage * 0.1 * GetStats(player_id).Intelligence
	return damage


func GetStats(player_id):
	return get_node("/root/Main/"+str(player_id)).player_stats


func FetchToken(player_id):
	rpc_id(player_id, "FetchToken")


remote func ReturnToken(token):
	var player_id = get_tree().get_rpc_sender_id()
	player_verification_process.Verify(player_id, token)


func ReturnTokenVerificationResults(player_id, result):
	rpc_id(player_id, "ReturnTokenVerificationResults", result)
