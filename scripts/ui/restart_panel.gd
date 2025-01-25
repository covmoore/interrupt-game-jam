extends UIPanel

@export var restart_button:Button
@export var main_menu_button:Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_button.connect("pressed", _on_RestartButton_pressed)
	main_menu_button.connect("pressed", _on_MainMenuButton_pressed)


func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

func _on_MainMenuButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/mainmenu.tscn")

func show():
	super()

func hide():
	super()
