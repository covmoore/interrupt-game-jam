class_name MindTrigger extends Area3D

var can_hack = false

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" and can_hack:
		get_tree().change_scene_to_file("res://maps/mind.tscn")

func make_hackable():
	can_hack = true
