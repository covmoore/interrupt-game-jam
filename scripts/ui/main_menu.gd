extends Control

func _ready() -> void:
	$Background/Buttons/Play.connect("pressed", _on_PlayButton_pressed)
	$Background/Buttons/Options.connect("pressed", _on_OptionsButton_pressed)
	$Background/Buttons/Quit.connect("pressed", _on_QuitButton_pressed)
	
func _on_PlayButton_pressed():
	get_tree().change_scene_to_file("res://maps/dungeon.tscn")
	
func _on_OptionsButton_pressed():
	print("implement this later")

func _on_QuitButton_pressed():
	get_tree().quit(0)
