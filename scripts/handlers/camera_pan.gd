extends Camera3D

@onready var camera_pivot = $".."
@onready var camera: Camera3D = $"."
var can_pan = true

# Zoom Variables
var zoom_speed = 2.0  # Adjust for finer control
var min_zoom = 20.0   # Minimum FOV (Zoom in)
var max_zoom = 90.0   # Maximum FOV (Zoom out)

@onready var mainCameraAnchor = $"../mainCameraAnchor"

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and can_pan:
		var mouse_sensitivity = 0.005
		camera_pivot.rotate_y(event.relative.x * mouse_sensitivity)
		#camera_pivot.rotate_x(event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -45, 0)
		camera_pivot.rotation.z = 0
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			# Zoom in by reducing the FOV
			camera.fov = clamp(camera.fov - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			# Zoom out by increasing the FOV
			camera.fov = clamp(camera.fov + zoom_speed, min_zoom, max_zoom)

func move_to_anchor(anchor: Node3D, hide_player: bool):
	global_transform = anchor.global_transform
	if hide_player:
		set_cull_mask_value(2, false)
		can_pan = false
	else:
		set_cull_mask_value(2, true)
		can_pan = true

func reset_camera():
	move_to_anchor(mainCameraAnchor, false)

func _on_player_ui_cancel_interaction() -> void:
	reset_camera()
