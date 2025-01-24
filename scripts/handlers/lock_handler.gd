extends StaticBody3D

@export var numbers: Node3D = null
@export var display: MeshInstance3D = null
@export var door: Interactable = null
@export var cam: Camera = null
@export var gameManager: GameManager = null
var buttons = []
var input = ""
@export var pin = ""
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
		gameManager.cancel_interaction()
		door.unlock_door()
	else:
		clear_display()

func set_display(code: String):
	if display.mesh is TextMesh:
		var txtMesh: TextMesh = display.mesh
		txtMesh.text = input

func clear_display():
	input = ""
	set_display(input)
