extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@onready var gun = $Pivot/Body/Gun
@onready var interactDetection = $AreaDetection

var battle_mesh = null
var mind_mesh = null

var Game = preload("res://scripts/managers/gameManager.gd")

var items_in_range: Array[Node3D] = []

var target_velocity = Vector3.ZERO
var canMove = true
var _camera: Camera3D = null
var RAY_LENGTH = 2000
enum PlayerCombatMode {
	KILLING_MODE = 0,
	MIND_MODE = 1
}
<<<<<<< Updated upstream
var player_combat_state: PlayerCombatMode = PlayerCombatMode.KILLING_MODE
=======
@onready var player_state: PlayerState = PlayerState.KILLING_MODE
>>>>>>> Stashed changes

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
			if result.has("collider"):
				var hovered_item: Node3D = result["collider"]
				if hovered_item != null and hovered_item is Interactable and hovered_item.can_be_selected():
					hovered_item.on_hover()
		if event is InputEventMouseButton and result.has("collider"):
			var selected_item: Node3D = get_item_from_list(result["collider"].name)
			if selected_item != null and selected_item is Interactable and selected_item.can_be_selected():
				selected_item.on_selected(_camera)
				canMove = false
				

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
	if room == Game.RoomType.DUNGEON:
		player_combat_state = PlayerCombatMode.KILLING_MODE
	elif room == Game.RoomType.MIND:
		player_combat_state = PlayerCombatMode.MIND_MODE
	set_player_context()

func set_player_context():
	if player_combat_state == PlayerCombatMode.KILLING_MODE:
		add_gun()
<<<<<<< Updated upstream
		set_player_mesh(battle_mesh)
	if player_combat_state == PlayerCombatMode.MIND_MODE:
		remove_gun()
		set_player_mesh(mind_mesh)
	
=======
		set_player_mesh_and_material($Pivot/Character_Mesh/Skeleton3D/Character.mesh, $Pivot/Character_Mesh/Skeleton3D/Character.mesh.surface_get_material(0))
		canShoot = true
		canMove = true
		canRotate = true
	elif player_state == PlayerState.IDLE or player_state == PlayerState.INSPECTING:
		remove_gun()
		#set_player_mesh(mind_mesh)
		canMove = true
		canShoot = false
		canRotate = true
	elif player_state == PlayerState.DEAD:
		canMove = false
		canShoot = false
		canRotate = false
		$".".rotation_degrees = Vector3(90,0,0)
		set_player_mesh_and_material($Pivot/Character_Mesh/Skeleton3D/Character.mesh, $Pivot/Character_Mesh/Skeleton3D/Character.mesh.surface_get_material(0))
>>>>>>> Stashed changes

func add_gun():
	gun.can_shoot = true
	gun.visible = true

func remove_gun():
	gun.can_shoot = false
	gun.visible = false

<<<<<<< Updated upstream
func set_player_mesh(mesh: Mesh):
	pass
=======
func set_player_mesh_and_material(_mesh: Mesh, _material: Material):
	_mesh.surface_set_material(0, _material)
	
func take_damage(dmg):
	health -= dmg
	player_ui.set_healthbar_value(health)
	var mat = $Pivot/Character_Mesh/Skeleton3D/Character.mesh.surface_get_material(0)
	if mat == null:
		print("Cringe... ~o~ the players's surface override material is null")
	else:
		var second_mat = mat.next_pass
		if second_mat == null:
			print("Cringe... ~o~ you forgot to add a next pass material to the original surface material override")
		else:
			$Pivot/Character_Mesh/Skeleton3D/Character.mesh.surface_set_material(0, second_mat)
			await get_tree().create_timer(0.1).timeout
			$Pivot/Character_Mesh/Skeleton3D/Character.mesh.surface_set_material(0, mat)
	if health <= 0:
		player_state = PlayerState.DEAD
		death_sound.play()
		set_player_context()
		player_ui.change_state(player_ui.UIState.DEAD)
	else:
		hurt_sound.play()
>>>>>>> Stashed changes

func _on_area_detection_body_entered(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.append(body)
		body.in_range(self)

func _on_area_detection_body_exited(body: Node3D) -> void:
	if body.get_groups().has("interactable"):
		items_in_range.remove_at(items_in_range.find(body))
		body.out_of_range(self)

func _on_exit_button_button_down() -> void:
	canMove = true
