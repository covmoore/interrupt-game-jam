@tool
extends StaticBody3D
class_name Interactable

var highlight_overlay = preload("res://materials/highlight.tres")
var isActive = false

@warning_ignore("unused_signal")
signal on_object_interacted
var isSubInteractable: bool = false
var parent: NodePath = ""

func _get_property_list() -> Array[Dictionary]:
	var ret: Array[Dictionary] = []
	
	ret.append({
		"name": "Is Sub Interactable",
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_DEFAULT
	})
	if isSubInteractable:
		ret.append({
			"name": "Parent",
			"type": TYPE_NODE_PATH,
			"hint": PROPERTY_HINT_NODE_TYPE,
			"hint_string": "",
			"usage": PROPERTY_USAGE_DEFAULT
		})
	
	return ret

func _set(prop_name: StringName, val) -> bool:
	var retval: bool = true
	match prop_name:
		"Is Sub Interactable":
			isSubInteractable = val
			notify_property_list_changed()
		"Parent":
			parent = val
			notify_property_list_changed()
		_:
			retval = false
	
	return retval

func _get(prop_name: StringName):
	match prop_name:
		"Is Sub Interactable":
			return isSubInteractable
		"Parent":
			return parent
	return null

func in_range(player: CharacterBody3D):
	if !isSubInteractable:
		for child in get_children():
			if child is MeshInstance3D:
				child.material_overlay = highlight_overlay
	else:
		var parent: Node = get_node(parent)
		if parent is Interactable and parent.isActive:
			for child in get_children():
				if child is MeshInstance3D:
					child.material_overlay = highlight_overlay

func out_of_range(player: CharacterBody3D):
	for child in get_children():
		if child is MeshInstance3D:
			child.material_overlay = null

func can_be_selected():
	if isActive:
		return false
	elif isSubInteractable:
		if get_node(parent).isActive:
			return true
		else:
			return false
	else:
		return true
	

func on_selected(cam: Camera3D):
	var temp = find_child("camera_anchor")
	if temp != null:
		cam.move_to_anchor(temp, true)
		for child in get_children():
			if child is MeshInstance3D:
				child.material_overlay = null
		emit_signal("on_object_interacted")
	isActive = true

func on_hover():
	if isSubInteractable and get_node(parent).isActive:
		for child in get_children():
			if child is MeshInstance3D:
				child.material_overlay = highlight_overlay
	
func _on_exit_button_button_down() -> void:
	isActive = false
	if isSubInteractable:
		get_node(parent).isActive = false
	print(isActive)
