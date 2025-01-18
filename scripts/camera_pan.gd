extends Camera3D

@onready var camera_pivot = $".."
@onready var camera: Camera3D = $"."

func _input(event: InputEvent):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var mouse_sensitivity = 0.005
		camera_pivot.rotate_y(event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -45, 0)
		camera_pivot.rotation.z = 0
# Called when the node enters the scene tree for the first time.
