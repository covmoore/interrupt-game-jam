@tool
class_name Inspectable extends Interactable

var highlight_overlay = preload("res://materials/highlight.tres")
var gameManager: GameManager = null
var isActive = false

@warning_ignore("unused_signal")
signal on_object_interacted
var isSubInteractable: bool = false
var parent_path: NodePath = "null"
var camera_path: NodePath = "null"
var camera:Camera3D = null

func _ready() -> void:
	gameManager = get_tree().get_root().get_child(0)

func _input(event: InputEvent) -> void:
	if camera == null and isSubInteractable:
		camera = get_node(camera_path)
	else:
		if isSubInteractable:
			if event is InputEventMouse:
				var space_state = get_world_3d().direct_space_state
				var mousepos = get_viewport().get_mouse_position()
				var origin = camera.project_ray_origin(mousepos)
				var end = origin + camera.project_ray_normal(mousepos) * 2000
				var query = PhysicsRayQueryParameters3D.create(origin, end)
				#query.exclude = [interactDetection, self]
				query.collide_with_areas = true
				var result = space_state.intersect_ray(query)
				
				if event is InputEventMouseMotion:
					if result.has("collider"):
						var hovered_item: Node3D = result["collider"]
						if hovered_item != null and hovered_item.name == self.name and not isActive:
							on_hover()
						else:
							off_hover()

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
		ret.append({
			"name": "Camera",
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
			parent_path = val
			notify_property_list_changed()
		"Camera":
			camera_path = val
			notify_property_list_changed()
		_:
			retval = false
	
	return retval

func _get(prop_name: StringName):
	match prop_name:
		"Is Sub Interactable":
			return isSubInteractable
		"Parent":
			return parent_path
		"Camera":
			return camera_path
	return null

func in_range(player: CharacterBody3D):
	if !isSubInteractable:
		for child in get_children():
			if child is MeshInstance3D:
				child.material_overlay = highlight_overlay
	else:
		var parent = get_node(parent_path)
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
		var parent = get_node(parent_path)
		if parent.isActive:
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
