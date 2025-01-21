extends StaticBody3D

@onready var numbers = $numbers
@onready var display: MeshInstance3D = $display/MeshInstance3D/MeshInstance3D
@onready var door = $".."
@onready var cam = $"../../../CameraPivot/Camera3D"
var buttons = []
var input = ""
var pin = "1234"
const MAX_LENGTH = 9
signal unlock_door
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = numbers.get_children()
	for button in buttons:
		button.connect("lock_button_pressed", button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func button_pressed(number: StringName):
	if number == "ENTER":
		check_passcode()
	elif input.length() < MAX_LENGTH:
		input += number
		set_display(input)

func check_passcode():
	if input == pin:
		emit_signal("unlock_door")
		cam.reset_camera()
		door.free()
	else:
		clear_display()

func set_display(code: String):
	if display.mesh is TextMesh:
		var txtMesh: TextMesh = display.mesh
		txtMesh.text = input

func clear_display():
	input = ""
	set_display(input)
