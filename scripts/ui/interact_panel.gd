extends UIPanel

@export var exit_button: Button = null
@export var back_button: Button = null
@export var ui_manager: UIManager = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func show():
	#print(gameManager.get_current_inspected())
	var cur_inspected = ui_manager.get_current_inspected()
	if cur_inspected != null and ui_manager.get_current_inspected().isSubInteractable:
		back_button.show()
	else:
		back_button.hide()
	super()

func hide():
	super()
