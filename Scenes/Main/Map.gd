extends Node

var enemy_id_counter = 1
var enemy_maximum = 4
var enemy_types = ["Enemy1"]
var enemy_spawn_points = [Vector2(700, 100), Vector2(600, 1100), Vector2(400, 700), Vector2(100, 600), Vector2(200, 300), Vector2(150, 900), Vector2(200, 750), Vector2(800, 1300), Vector2(800, 700)]
var open_locations = []
var occupied_locations = {}
var enemy_list = {}

onready var game_server = get_node("/root/GameServer")

func _ready():
	for i in enemy_spawn_points.size():
		open_locations.append(i)
	var timer = Timer.new()
	timer.wait_time = 3
	timer.autostart = true
	timer.connect("timeout", self, "SpawnEnemy")
	self.add_child(timer)

func SpawnEnemy():
#	print("enemies: ", enemy_list)
	if enemy_list.size() >= enemy_maximum:
		pass
	else:
		randomize()
		var type = enemy_types[randi() % enemy_types.size()]
		var rng_location_index = randi() % open_locations.size()
		var location = enemy_spawn_points[open_locations[rng_location_index]]
		occupied_locations[enemy_id_counter] = open_locations[rng_location_index]
		open_locations.remove(rng_location_index)
		enemy_list[enemy_id_counter] = {
			"EnemyType": type,
			"EnemyLocation": location,
			"EnemyHealth": 500,
			"EnemyMaxHealth": 500,
			"EnemyState": "Idle",
			"time_out": 1
		}
		get_node("/root/GameServer/WorldMap").SpawnEnemy(enemy_id_counter, location)
		enemy_id_counter += 1
	for enemy in enemy_list.keys():
		if enemy_list[enemy]["EnemyState"] == "Dead":
			if enemy_list[enemy]["time_out"]  == 0:
				enemy_list.erase(enemy)
				game_server.DespawnEnemy(enemy)
			else:
				enemy_list[enemy]["time_out"] -= 1 

func NPCHit(enemy_id, damage):
	if enemy_list.has(enemy_id):
		if enemy_list[enemy_id]["EnemyHealth"] <= 0:
			pass
		else:
			enemy_list[enemy_id]["EnemyHealth"] = enemy_list[enemy_id]["EnemyHealth"] - damage
			if enemy_list[enemy_id]["EnemyHealth"] <= 0:
				get_node("/root/GameServer/WorldMap/YSort/Enemies/" + str(enemy_id)).queue_free()
				enemy_list[enemy_id]["EnemyState"] = "Dead"
				open_locations.append(occupied_locations[enemy_id])
				occupied_locations.erase(enemy_id)
