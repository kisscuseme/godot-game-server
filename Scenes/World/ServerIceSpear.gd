extends RigidBody2D

var projectile_speed = 600
var life_time = 3
var direction
var impulse_rotation
var player_id
var damage


func _ready():
	SetDamage()
	apply_impulse(Vector2.ZERO, Vector2(projectile_speed, 0).rotated(impulse_rotation))
	SelfDestruct()
	$CollisionShape2D.rotation = impulse_rotation


func SetDamage():
	damage = Game.skill_data["Ice Spear"].Damage * (0.1 * get_node("/root/Main/" + str(player_id)).player_stats.Intelligence)


func SelfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()


func _on_IceSpear_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	if body.is_in_group("NPCEnemies"):
		var enemy_id = int(body.name)
		get_node("/root/Main/Map").NPCHit(enemy_id, damage)
		print(damage)
	self.hide()
