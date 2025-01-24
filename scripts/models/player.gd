class_name Player extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var gun: Node3D = null
@export var interactDetection: Area3D = null
@export var health = 5

var battle_mesh = null
var mind_mesh = null

var items_in_range: Array[Node3D] = []

var target_velocity = Vector3.ZERO
var canMove = true
var canShoot = true
var canRotate = true
var _camera: Camera3D = null
var RAY_LENGTH = 2000
enum PlayerState {
	KILLING_MODE = 0,
	IDLE,
	INSPECTING,
	DEAD
}
var player_state: PlayerState = PlayerState.KILLING_MODE

var inpectRadius = 5.0

signal on_enemy_killed

func _ready() -> void:
	_camera = $"../CameraPivot/Camera3D"

func get_detection_list(selected: String):
	for item in items_in_range:
		if item.name == selected:
			return item
	return null

func get_interact_collider():
	return interactDetection

func player_look_at(pos: Vector3):
	if canRotate:
		pos.y = global_transform.origin.y
		$Pivot.look_at(pos)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and canShoot:
		gun.shoot()

func _physics_process(delta: float):
	var movement = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(movement.x, 0, movement.y).rotated(Vector3.UP, _camera.global_rotation.y).normalized()
	if direction:
		direction = direction.normalized()
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	if canMove:
		move_and_slide()
	
	# Interacting Code

func killed_enemy(enemy: CharacterBody3D):
	emit_signal("on_enemy_killed")

func change_state(state: PlayerState):
	player_state = state
	set_player_context()

func set_player_context():
	if player_state == PlayerState.KILLING_MODE:
		add_gun()
		set_player_mesh(battle_mesh)
		canShoot = true
		canMove = true
		canRotate = true
	elif player_state == PlayerState.IDLE or player_state == PlayerState.INSPECTING:
		remove_gun()
		set_player_mesh(mind_mesh)
		canMove = true
		canShoot = false
		canRotate = true
	elif player_state == PlayerState.DEAD:
		canMove = false
		canShoot = false
		canRotate = false
		$".".rotation_degrees = Vector3(90,0,0)

func add_gun():
	gun.can_shoot = true
	gun.visible = true

func remove_gun():
	gun.can_shoot = false
	gun.visible = false

func set_player_mesh(mesh: Mesh):
	pass
	
func take_damage(dmg):
	health -= dmg
	if health <= 0:
		player_state = PlayerState.DEAD
		set_player_context()

func _on_area_detection_body_entered(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.append(body)
		body.in_range(self)

func _on_area_detection_body_exited(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.remove_at(items_in_range.find(body))
		body.out_of_range(self)
