extends Node

@export var bullet_scene: PackedScene
@export var shoot_speed: float = 50.0
@export var fire_rate: float = 0.2
var can_shoot = true

func shoot():
	if can_shoot:
		can_shoot = false
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_transform.origin = $Muzzle.global_transform.origin
		bullet.call_deferred("initialize_bullet", $Muzzle.global_transform.origin + $Muzzle.global_transform.basis.z, shoot_speed)
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true
