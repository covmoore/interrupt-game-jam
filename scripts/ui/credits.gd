extends Control

@export var go_back_button:Button = null

func _ready() -> void:
	go_back_button.connect("pressed", _on_GoBackButton_clicked)

func _on_GoBackButton_clicked():
	get_tree().change_scene_to_file("res://maps/mainmenu.tscn")
