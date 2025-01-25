extends Area3D


func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://maps/mind.tscn")
