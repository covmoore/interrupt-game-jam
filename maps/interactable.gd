extends StaticBody3D
#class_name Interactable

var highlight_overlay = preload("res://materials/highlight.tres")
signal on_object_interacted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func in_range():
	for child in get_children():
		if child is MeshInstance3D:
			child.material_overlay = highlight_overlay

func out_of_range():
	for child in get_children():
		if child is MeshInstance3D:
			child.material_overlay = null

func on_selected(cam: Camera3D):
	var temp = find_child("camera_anchor")
	if temp != null:
		cam.move_to_anchor(temp, true)
		emit_signal("on_object_interacted")
