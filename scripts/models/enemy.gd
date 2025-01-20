extends CharacterBody3D

@onready var player = $"../Player"
@onready var nav_agent = $NavigationAgent3D

@export var movement_speed : float = 2.0

var movement_target_position : Vector3 = Vector3.ZERO
var path = []

func _ready():
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	
func set_movement_target(movement_target: Vector3):
	nav_agent.set_target_position(movement_target)
	
func actor_setup():
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(player.global_transform.origin)
	
func _physics_process(delta):
	actor_setup()
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_position = global_position
	var next_path_position = nav_agent.get_next_path_position()
	
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
