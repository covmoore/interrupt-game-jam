class_name UIManager extends Control

enum UIState {
	KILLING = 0,
	IDLE,
	INSPECTING
}
var ui_state = UIState.KILLING
@onready var cam: Camera3D = $"../CameraPivot/Camera3D"
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var hud = $CanvasLayer/MarginContainer/hud
@onready var interactMenu = $CanvasLayer/MarginContainer/interactMenu
@onready var gameManager: GameManager = $".."
signal cancel_interaction
var panels = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panels = [hud, interactMenu]
	show_panels([hud])
	#interactMenu.visible = false
	var interactables = get_tree().get_nodes_in_group("interactable")
	#for interactable in interactables:
		#if interactable is Inspectable:
			#interactable.connect("on_object_inspected", _on_object_inspected)

func change_state(state: UIState):
	ui_state = state
	set_context()

func set_context():
	if ui_state == UIState.KILLING:
		pass
	if ui_state == UIState.IDLE:
		show_panels([hud])
	if ui_state == UIState.INSPECTING:
		show_panels([interactMenu])

#func _on_object_inspected() -> void:
	#show_panels([interactMenu])
	

func show_panels(curPanel: Array[Control]):
	for panel in panels:
		if curPanel.has(panel):
			panel.show()
		else:
			panel.hide()

func _on_exit_button_button_down() -> void:
	gameManager.cancel_interaction()
