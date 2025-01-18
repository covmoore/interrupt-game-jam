extends Node

@export var bullet_scene: PackedScene
@export var shoot_speed: float = 50.0
@export var fire_rate: float = 0.2
var can_shoot = true

func shoot():
	if can_shoot:
		can_shoot = false
		var bullet = bullet_scene.instantiate()
		
		# Set the initial position before adding to the tree
		bullet.global_transform.origin = $Muzzle.global_transform.origin
		
		# Add the bullet to the scene tree first
		get_tree().root.add_child(bullet)
		
		# Look at the target and set velocity after it's in the tree
		bullet.look_at_from_position(
			bullet.global_transform.origin,
			$Muzzle.global_transform.origin + $Muzzle.global_transform.basis.z,
			Vector3.UP
		)
		bullet.linear_velocity = bullet.global_transform.basis.z * shoot_speed
		
		# Handle fire rate cooldown
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true
