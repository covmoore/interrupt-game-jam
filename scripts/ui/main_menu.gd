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
	var credits_url = "https://drive.google.com/drive/folders/1PgYbVBYbB8uqkt6pU1wZYw5d4E-D_dL2?usp=drive_link"
	# Check if running in the editor or not WebGL
	if OS.has_feature("editor") or OS.get_name() != "Web":
		OS.shell_open(credits_url)
	else:
		JavaScriptBridge.eval('window.open(%s, "_blank")' % credits_url)

func _on_QuitButton_pressed():
	get_tree().quit(0)
