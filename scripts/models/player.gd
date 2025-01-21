class_name Player extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@onready var gun = $Pivot/Body/Gun
@onready var interactDetection = $AreaDetection

var battle_mesh = null
var mind_mesh = null

var items_in_range: Array[Node3D] = []

var target_velocity = Vector3.ZERO
var canMove = true
var _camera: Camera3D = null
var RAY_LENGTH = 2000
enum PlayerCombatMode {
	KILLING_MODE = 0,
	MIND_MODE = 1
}
var player_combat_state: PlayerCombatMode = PlayerCombatMode.KILLING_MODE

var inpectRadius = 5.0

func _ready() -> void:
	_camera = $"../CameraPivot/Camera3D"

func _input(event: InputEvent):
	if event is InputEventMouse:
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var origin = _camera.project_ray_origin(mousepos)
		var end = origin + _camera.project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.exclude = [interactDetection, self]
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		if event is InputEventMouseMotion:
			if result.has("position") :  
				result["position"].y = global_transform.origin.y
				$Pivot.look_at(result["position"])
		if event.is_pressed() and result.has("collider"):
			var selected_item: Node3D = get_item_from_list(result["collider"].name)
			if selected_item != null and selected_item is Interactable and selected_item.can_be_selected():
				selected_item.on_selected(_camera, self)

func get_item_from_list(selected: String):
	for item in items_in_range:
		if item.name == selected:
			return item
	return null

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
	velocity = target_velocity
	if canMove:
		move_and_slide()
	
	# Interacting Code
	

func set_player_combat_mode(room):
	if room == GameManager.RoomType.DUNGEON:
		player_combat_state = PlayerCombatMode.KILLING_MODE
	elif room == GameManager.RoomType.MIND:
		player_combat_state = PlayerCombatMode.MIND_MODE
	set_player_context()

func set_player_context():
	if player_combat_state == PlayerCombatMode.KILLING_MODE:
		add_gun()
		set_player_mesh(battle_mesh)
	if player_combat_state == PlayerCombatMode.MIND_MODE:
		remove_gun()
		set_player_mesh(mind_mesh)
	

func add_gun():
	gun.can_shoot = true
	gun.visible = true

func remove_gun():
	gun.can_shoot = false
	gun.visible = false

func set_player_mesh(mesh: Mesh):
	pass

func _on_area_detection_body_entered(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.append(body)
		body.in_range(self)

func _on_area_detection_body_exited(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.remove_at(items_in_range.find(body))
		body.out_of_range(self)

func _on_player_ui_cancel_interaction() -> void:
	canMove = true
