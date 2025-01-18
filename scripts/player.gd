extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20

var target_velocity = Vector3.ZERO
var _camera: Camera3D = null

func _ready() -> void:
	_camera = $"../CameraPivot/Camera3D"

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		$Pivot.basis = Basis.looking_at(Vector3(event.global_position.x, event.global_position.y, 0))

func _physics_process(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, _camera.global_rotation.y).normalized()
	if direction:
		direction = direction.normalized()
		
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity = target_velocity
	move_and_slide()

	
