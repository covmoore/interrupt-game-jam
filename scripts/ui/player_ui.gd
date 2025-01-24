class_name UIManager extends Control

enum UIState {
	KILLING = 0,
	IDLE,
	INSPECTING
}
var ui_state = UIState.KILLING
@export var cam: Camera3D = null
@export var canvas: CanvasLayer = null
@export var hud: UIPanel = null
@export var healthbar: ProgressBar = null
@export var interactMenu: UIPanel = null
@export var gameManager: GameManager = null
signal cancel_interaction
var panels = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panels = [hud, interactMenu]
	show_panels([hud])
	var interactables = get_tree().get_nodes_in_group("interactable")

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

func show_panels(curPanel: Array[Control]):
	for panel in panels:
		if curPanel.has(panel):
			panel.show()
		else:
			panel.hide()
			
func set_healthbar_value(value:int):
	healthbar.value = value

func get_current_inspected():
	return gameManager.get_current_inspected()

func _on_exit_button_button_down() -> void:
	gameManager.cancel_interaction()


func _on_back_button_button_down() -> void:
	gameManager.back_interaction()
