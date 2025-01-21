extends Control

@onready var cam: Camera3D = $"../CameraPivot/Camera3D"
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var hud = $CanvasLayer/MarginContainer/hud
@onready var interactMenu = $CanvasLayer/MarginContainer/interactMenu
signal cancel_interaction
var panels = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panels = [hud, interactMenu]
	show_panels([hud])
	#interactMenu.visible = false
	var interactables = get_tree().get_nodes_in_group("interactable")
	for interactable in interactables:
		if interactable is Inspectable:
			interactable.connect("on_object_inspected", _on_object_inspected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_object_inspected() -> void:
	show_panels([interactMenu])
	#interactMenu.visible = true
	

func show_panels(curPanel: Array[Control]):
	for panel in panels:
		if curPanel.has(panel):
			panel.show()
		else:
			panel.hide()

func _on_exit_button_button_down() -> void:
	show_panels([hud])
	emit_signal("cancel_interaction")
