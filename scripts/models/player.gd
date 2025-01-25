class_name Player extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var gun: Node3D = null
@export var interactDetection: Area3D = null
@export var player_ui: Control
@export var health = 5
@export var camera: Camera = null
@onready var death_sound
@onready var hurt_sound

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
	death_sound = AudioStreamPlayer.new()
	hurt_sound = AudioStreamPlayer.new()
	death_sound.stream = preload("res://sounds/male_death_intense_scream.wav")
	hurt_sound.stream = preload("res://sounds/male_pain_damage_impact.wav")
	add_child(death_sound)
	add_child(hurt_sound)
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
		var enemy = null
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var origin =  camera.project_ray_origin(mousepos)
		var end = origin + camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		#query.exclude = [interact_collider, self]
		query.exclude = camera.get_exclusion_rids()
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		if result.has("collider") and result["collider"] is Enemy:
			enemy = result["collider"]
		gun.shoot(enemy)

func _physics_process(_delta: float):
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

func killed_enemy(_enemy: CharacterBody3D):
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

func set_player_mesh(_mesh: Mesh):
	pass
	
func take_damage(dmg):
	health -= dmg
	player_ui.set_healthbar_value(health)
	var body_mat = $Pivot/Body.get_surface_override_material(0) as StandardMaterial3D
	var head_mat = $Pivot/Head.get_surface_override_material(0) as StandardMaterial3D
	if body_mat == null or head_mat == null:
		print("Cringe... ~o~ the players's surface override material is null")
	else:
		var second_mat_body = body_mat.next_pass
		var second_mat_head = head_mat.next_pass
		if second_mat_body == null or second_mat_head == null:
			print("Cringe... ~o~ you forgot to add a next pass material to the original surface material override")
		else:
			$Pivot/Body.set_surface_override_material(0, second_mat_body)
			$Pivot/Head.set_surface_override_material(0, second_mat_head)
			await get_tree().create_timer(0.1).timeout
			$Pivot/Body.set_surface_override_material(0, body_mat)
			$Pivot/Head.set_surface_override_material(0, head_mat)
	if health <= 0:
		player_state = PlayerState.DEAD
		death_sound.play()
		set_player_context()
		player_ui.change_state(player_ui.UIState.DEAD)
	else:
		hurt_sound.play()

func _on_area_detection_body_entered(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.append(body)
		body.in_range()

func _on_area_detection_body_exited(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.remove_at(items_in_range.find(body))
		body.out_of_range()
