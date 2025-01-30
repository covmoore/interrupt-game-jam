extends UIPanel

@export var player_ui:UIManager = null
@export var back_button:Button = null

func  _ready() -> void:
	back_button.connect("pressed", _on_back_button_pressed)

func _on_back_button_pressed():
	player_ui.show_panels([player_ui.pauseMenu])

func show():
	super()

func hide():
	super()
