extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@onready var gun = $Pivot/Body/Gun

var Game = preload("res://scripts/managers/gameManager.gd")

var target_velocity = Vector3.ZERO
var _camera: Camera3D = null
var RAY_LENGTH = 2000
enum PlayerCombatMode {
	KILLING_MODE = 0,
	MIND_MODE = 1
}

var inpectRadius = 5.0

func _ready() -> void:
	_camera = $"../CameraPivot/Camera3D"

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()

		var origin = _camera.project_ray_origin(mousepos)
		var end = origin + _camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		if result.has("position") :  
			result["position"].y = global_transform.origin.y
			$Pivot.look_at(result["position"])
			

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(("fire")):
		gun.shoot()

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

func set_player_combat_mode(room):
	if room == Game.RoomType.DUNGEON:
		PlayerCombatMode.KILLING_MODE
	elif room == Game.RoomType.MIND:
		PlayerCombatMode.MIND_MODE
