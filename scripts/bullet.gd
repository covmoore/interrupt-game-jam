extends RigidBody3D

@export var lifespan: float = 2.0
@export var speed: float = 50.0

func _ready():
	await(get_tree().create_timer(lifespan)).timeout
	queue_free()

func initialize_bullet(target_position: Vector3, bullet_speed: float):
	look_at_from_position(global_transform.origin, target_position, Vector3.UP)
	linear_velocity = global_transform.basis.z * bullet_speed
	
func _process(delta: float) -> void:
	global_transform.origin += global_transform.basis.z * -1 * speed * delta
