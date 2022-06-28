extends Node

onready var game_server = get_node("/root/GameServer")
onready var map = game_server.get_node("Map")

var sync_clock_counter = 0
var world_state = {}

func _physics_process(_delta):
	sync_clock_counter += 1
	if sync_clock_counter == 3:
		sync_clock_counter = 0
		if not GlobalData.player_state_collection.empty():
			world_state = GlobalData.player_state_collection.duplicate(true)
			for player in world_state.keys():
				world_state[player].erase("T")
			world_state["T"] = OS.get_system_time_msecs()
			world_state["Enemies"] = map.enemy_list
			# Verifications
			# Anti-Cheat
			# Cuts (chunking / mpas)
			# physic checks
			# Anything else you have to do
			game_server.SendWorldState(world_state)
