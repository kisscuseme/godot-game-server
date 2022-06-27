extends Node

onready var map = get_node("/root/Main/Map")

var sync_clock_counter = 0
var world_state = {}

func _physics_process(_delta):
	sync_clock_counter += 1
	if sync_clock_counter == 3:
		sync_clock_counter = 0
		if not Game.player_state_collection.empty():
			world_state = Game.player_state_collection.duplicate(true)
			for player in world_state.keys():
				world_state[player].erase("T")
			world_state["T"] = OS.get_system_time_msecs()
			world_state["Enemies"] = map.enemy_list
			# Verifications
			# Anti-Cheat
			# Cuts (chunking / mpas)
			# physic checks
			# Anything else you have to do
			Game.SendWorldState(world_state)
