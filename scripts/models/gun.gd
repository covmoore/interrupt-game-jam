extends Node3D

@export var bullet_scene: PackedScene
@export var muzzle_speed: float = 50.0
@export var fire_rate:float = 0.2
var can_shoot = true

func shoot():
	if can_shoot:
		can_shoot = false
		var new_bullet = bullet_scene.instantiate()
		new_bullet.global_transform = $Muzzle.global_transform
		#new_bullet.speed = muzzle_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet)
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true
