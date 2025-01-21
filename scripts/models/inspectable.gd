@tool
class_name Inspectable extends Interactable

signal on_object_inspected

func _ready() -> void:
	gameManager = get_tree().get_root().get_child(0)

func can_be_selected():
	if isActive:
		return false
	elif isSubInteractable:
		var parent = get_node(parent_path)
		if parent.isActive:
			return true
		else:
			return false
	else:
		return true
	

func on_selected(cam: Camera3D, player: Player):
	var temp = find_child("camera_anchor")
	if temp != null:
		cam.move_to_anchor(temp, true)
	emit_signal("on_object_inspected")
	super(cam, player)

func on_hover():
	var parent = get_node(parent_path)
	if isSubInteractable and parent.isActive:
		for child in get_children():
			if child is MeshInstance3D:
				child.material_overlay = highlight_overlay

func off_hover():
	var parent = get_node(parent_path)
	if isSubInteractable and parent.isActive:
		for child in get_children():
			if child is MeshInstance3D:
				child.material_overlay = null

func conect_button(uiManager: Control):
	uiManager.connect("cancel_interaction", _on_exit_button_button_down)

func _on_exit_button_button_down() -> void:
	isActive = false
	if isSubInteractable:
		var parent = get_node(parent_path)
		parent.isActive = false
