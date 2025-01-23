class_name Camera extends Camera3D

enum CameraState {
	GLOBAL = 0,
	FOCUSED = 1
}
@export var camera_pivot: Node3D = null
@export var player: Player = null
@export var mainCameraAnchor: Node3D = null
@export var gameManager: GameManager = null
var can_pan = true
var current_state: CameraState = CameraState.GLOBAL
var hovered_item = null

# Zoom Variables
var zoom_speed = 2.0  # Adjust for finer control
var min_zoom = 20.0   # Minimum FOV (Zoom in)
var max_zoom = 90.0   # Maximum FOV (Zoom out)
const RAY_LENGTH = 2000
var interact_collider = null

var walls = []
var col_rids = []

func _ready() -> void:
	interact_collider = player.get_interact_collider()
	walls = get_tree().get_nodes_in_group("Wall")
	for wall in walls:
		col_rids.append(wall.get_rid())
	col_rids.append_array([interact_collider, self])
func _input(event: InputEvent):
	if event is InputEventMouse:
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()
		var origin = project_ray_origin(mousepos)
		var end = origin + project_ray_normal(mousepos) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		#query.exclude = [interact_collider, self]
		query.exclude = col_rids
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
			
		if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and can_pan:
			var mouse_sensitivity = 0.005
			camera_pivot.rotate_y(event.relative.x * mouse_sensitivity)
			#camera_pivot.rotate_x(event.relative.y * mouse_sensitivity)
			camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -45, 0)
			camera_pivot.rotation.z = 0
			
		if result.has("position") :  
					player.player_look_at(result["position"])
		
		if result.has("collider") and result["collider"] is Interactable:
			var item: Interactable = result["collider"]
			if event.is_pressed() and item.can_be_selected():
				if current_state == CameraState.GLOBAL:
					var selected_item: Node3D = player.get_detection_list(item.name)
					if selected_item != null:
						select_interactable(selected_item)
				else:
					select_interactable(item)

			if hovered_item != null:
				if item.name != hovered_item.name:
					hovered_item.off_hover()
					if item.isSubInteractable and not item.isActive:
						item.on_hover()
					hovered_item = item
			else:
				if item.isSubInteractable and not item.isActive:
					item.on_hover()
					hovered_item = item
		
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
				# Zoom in by reducing the FOV
				fov = clamp(fov - zoom_speed, min_zoom, max_zoom)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
				# Zoom out by increasing the FOV
				fov = clamp(fov + zoom_speed, min_zoom, max_zoom)

func change_state(state: CameraState):
	current_state = state
	set_context()

func set_context():
	if current_state == CameraState.GLOBAL:
		reset_camera()

func select_interactable(selected_item):
	selected_item.on_selected(self, player)
	if selected_item is Inspectable:
		gameManager.change_state(GameManager.GameState.INSPECTING)
	

func move_to_anchor(anchor: Node3D, hide_player: bool):
	global_transform = anchor.global_transform
	if hide_player:
		set_cull_mask_value(2, false)
		can_pan = false
	else:
		set_cull_mask_value(2, true)
		can_pan = true

func reset_camera():
	#transform = camera_pivot.transform
	#print(mainCameraAnchor)
	move_to_anchor(mainCameraAnchor, false)
