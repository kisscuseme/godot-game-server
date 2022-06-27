extends Node

var icespear = preload("res://Scenes/World/ServerIceSpear.tscn")
var enemy_spawn = preload("res://Scenes/World/ServerEnemy.tscn")

func SpawnAttack(spawn_time, a_rotation, a_position, a_direction, player_id):
	var icespear_instance = icespear.instance()
	icespear_instance.player_id = player_id
	icespear_instance.impulse_rotation = a_rotation
	icespear_instance.position = a_position
	icespear_instance.direction = a_direction
	add_child(icespear_instance)


func SpawnEnemy(enemy_id, location):
	var new_enemy = enemy_spawn.instance()
	new_enemy.position = location
	new_enemy.name = str(enemy_id)
	$YSort/Enemies.add_child(new_enemy, true)
