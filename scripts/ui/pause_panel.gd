extends UIPanel

@export var return_button:Button = null
@export var options_button:Button = null
@export var resume_button:Button = null
@export var player_ui:UIManager

func _ready() -> void:
	resume_button.connect("pressed", _on_resume_button_clicked)
	return_button.connect("pressed", _on_return_button_clicked)
	options_button.connect("pressed", _on_options_button_clicked)

func _on_resume_button_clicked():
	player_ui.toggle_pause()
	
func _on_return_button_clicked():
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://maps/mainmenu.tscn")

func _on_options_button_clicked():
	player_ui.show_panels([player_ui.optionsMenu])

func show():
	super()

func hide():
	super()
