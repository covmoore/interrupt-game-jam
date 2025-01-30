@tool
class_name Inspectable extends Interactable

func can_be_selected():
	if isActive:
		return false
	elif isSubInteractable:
		parent = get_node(parent_path)
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
	self.gameManager =  get_tree().get_root().get_child(0)
	self.gameManager.set_current_inspected(self)
	super(cam, player)

func on_hover():
	if isSubInteractable:
		print("based")
		parent = get_node(parent_path)
		if parent.isActive:
			for child in get_children():
				if child is MeshInstance3D:
					child.material_overlay = highlight_overlay

func off_hover():
	if isSubInteractable:
		parent = get_node(parent_path)
		if parent.isActive:
			for child in get_children():
				if child is MeshInstance3D:
					child.material_overlay = null

func connect_button(gameManager: GameManager):
	gameManager.connect("on_cancel_interaction", _on_exit_button_down)
	gameManager.connect("on_back_interaction", _on_back_button_down)


func _on_exit_button_down() -> void:
	isActive = false
	if isSubInteractable:
		parent = get_node(parent_path)
		parent.isActive = false

func _on_back_button_down():
	isActive = false
	if isSubInteractable:
		var parent = get_node(parent_path)
		parent.isActive = true
