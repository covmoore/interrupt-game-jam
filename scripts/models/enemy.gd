class_name Enemy extends CharacterBody3D

@onready var player = $"../Player"
@onready var nav_agent = $NavigationAgent3D
@export var movement_speed : float = 2.0
@export var health: float = 0.0

@export var attack_range: float = 5.0

var movement_target_position : Vector3 = Vector3.ZERO
var path = []

func _ready():
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	
func set_movement_target(movement_target: Vector3):
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
	
func _physics_process(delta):
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
	move_and_slide()
	
func shoot_at_player():
	print("Pew pew! Suck my ass!!!!!")

func take_damage(shot_by: CharacterBody3D, dmg: float):
	health -= dmg
	if health <= 0:
		shot_by.killed_enemy(self)
		queue_free()
