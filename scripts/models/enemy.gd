class_name Enemy extends CharacterBody3D

@onready var player = $"../Player"
@onready var nav_agent = $NavigationAgent3D
@export var enemy_gun: Node3D = null  
@export var movement_speed : float = 2.0
@export var health: float = 0.0
@export var attack_range: float = 5.0
@export var spawning_fx: PackedScene = null
var movement_target_position : Vector3 = Vector3.ZERO
var can_move = true
var can_shoot = true
var path = []

func _ready():
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5

func spawn():
	var collision: CollisionShape3D = find_child("CollisionShape3D")
	collision.disabled = true
	visible = false
	can_move = false
	can_shoot = false
	var scene_root = get_tree().get_root().get_children()[0]
	var fx = spawning_fx.instantiate()
	fx.global_transform = global_transform
	scene_root.add_child(fx)
	await pause(2, get_tree())
	fx.free()
	visible = true
	collision.disabled = false
	can_move = true
	can_shoot = true
	
func set_movement_target(_movement_target: Vector3):
	#Instead of going straight to the player pick a random offset
	#to avoid bunching up
	var offset_distance = 2.0
	var random_angle = randf_range(0, TAU)
	var offset_x = cos(random_angle) * offset_distance
	var offset_z = sin(random_angle) * offset_distance
	
	var target_pos = player.global_transform.origin + Vector3(offset_x, 0, offset_z)
	nav_agent.set_target_position(target_pos)
	
func actor_setup():
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(player.global_transform.origin)
	
func _physics_process(_delta):
	if player.player_state != Player.PlayerState.DEAD:
		actor_setup()
		var distance_to_player = global_position.distance_to(player.global_transform.origin)
		
		#If close enough to attack
		if distance_to_player <= attack_range:
			#Stop moving
			velocity = Vector3.ZERO
			#Face the player
			look_at(player.global_transform.origin, Vector3.UP)
			#call you shooting logic
			shoot_at_player()
		else:
			#otherwise, keep using the nav agent
			if not nav_agent.is_navigation_finished():
				var next_path_position = nav_agent.get_next_path_position()
				velocity = global_position.direction_to(next_path_position) * movement_speed
			else:
				velocity = Vector3.ZERO
		if can_move:
			move_and_slide()
	
func shoot_at_player():
	if can_shoot:
		enemy_gun.shoot()

func take_damage(shot_by: CharacterBody3D, dmg: float):
	health -= dmg
	var mat = $Body.get_surface_override_material(0) as StandardMaterial3D
	if mat == null:
		print("Cringe... ~o~ the enemy's surface override material is null")
	else:
		var second_mat = mat.next_pass
		if second_mat == null:
			print("Cringe... ~o~ you forgot to add a next pass material to the original surface material override")
		else:
			$Body.set_surface_override_material(0, second_mat)
			await get_tree().create_timer(0.1).timeout
			$Body.set_surface_override_material(0, mat)
	if health <= 0:
		shot_by.killed_enemy(self)
		queue_free()

func pause(time: float, tree: SceneTree):
	await tree.create_timer(time).timeout
