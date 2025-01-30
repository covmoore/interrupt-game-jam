extends Control

@export var back_button: Button = null

func  _ready() -> void:
	back_button.connect("pressed", _on_back_button_pressed)
	
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://maps/mainmenu.tscn")
