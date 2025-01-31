extends UIPanel

@export var play_again_button:Button = null
@export var return_button:Button = null

func _ready() -> void:
	play_again_button.connect("pressed", _on_PlayAgainButton_clicked)
	return_button.connect("pressed", _on_ReturnButton_clicked)
	
func _on_PlayAgainButton_clicked():
	get_tree().change_scene_to_file("res://maps/dungeon.tscn")
	
func _on_ReturnButton_clicked():
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://maps/mainmenu.tscn")
