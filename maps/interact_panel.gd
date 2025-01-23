extends UIPanel

@onready var exit_button = $exit_buttons/exit_button
@onready var back_button = $exit_buttons/back_button
@onready var gameManager: GameManager = $"../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show():
	#print(gameManager.get_current_inspected())
	var cur_inspected = gameManager.get_current_inspected()
	if cur_inspected != null and gameManager.get_current_inspected().isSubInteractable:
		back_button.show()
	else:
		back_button.hide()
	super()

func hide():
	super()
