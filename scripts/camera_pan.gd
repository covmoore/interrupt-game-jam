extends Camera3D

@onready var camera_pivot = $".."
@onready var camera: Camera3D = $"."

# Zoom variables
var zoom_speed = 2.0  # Adjust for finer control
var min_zoom = 20.0   # Minimum FOV (Zoom in)
var max_zoom = 90.0   # Maximum FOV (Zoom out)

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mouse_sensitivity = 0.005
		camera_pivot.rotate_y(event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -45, 0)
		camera_pivot.rotation.z = 0

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			# Zoom in by reducing the FOV
			camera.fov = clamp(camera.fov - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			# Zoom out by increasing the FOV
			camera.fov = clamp(camera.fov + zoom_speed, min_zoom, max_zoom)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
