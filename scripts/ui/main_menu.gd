extends Control

@export var play_button:Button = null
@export var options_button:Button = null
@export var credits_button:Button = null
@export var quit_button:Button = null

func _ready() -> void:
	play_button.connect("pressed", _on_PlayButton_pressed)
	options_button.connect("pressed", _on_OptionsButton_pressed)
	credits_button.connect("pressed", _on_CreditsButton_pressed)
	quit_button.connect("pressed", _on_QuitButton_pressed)
	
func _on_PlayButton_pressed():
	get_tree().change_scene_to_file("res://maps/dungeon.tscn")
	
func _on_OptionsButton_pressed():
	get_tree().change_scene_to_file("res://maps/options.tscn")
	
func _on_CreditsButton_pressed():
	get_tree().change_scene_to_file("res://prefabs/credits.tscn")

func _on_QuitButton_pressed():
	get_tree().quit(0)
