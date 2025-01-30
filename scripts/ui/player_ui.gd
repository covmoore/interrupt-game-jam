class_name UIManager extends Control

enum UIState {
	KILLING = 0,
	IDLE,
	INSPECTING,
	PAUSED,
	DEAD
}
var ui_state = UIState.KILLING
@export var cam: Camera3D = null
@export var canvas: CanvasLayer = null
@export var hud: UIPanel = null
@export var healthbar: ProgressBar = null
@export var interactMenu: UIPanel = null
@export var gameManager: GameManager = null
@export var optionsMenu:UIPanel = null
@export var restartMenu: UIPanel = null
@export var pauseMenu: UIPanel = null
@export var player:Player = null

signal cancel_interaction
var panels = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panels = [hud, interactMenu, restartMenu, pauseMenu, optionsMenu]
	show_panels([hud])
	var interactables = get_tree().get_nodes_in_group("interactable")

func change_state(state: UIState):
	ui_state = state
	set_context()

func set_context():
	if ui_state == UIState.KILLING:
		show_panels([hud])
	if ui_state == UIState.IDLE:
		show_panels([hud])
	if ui_state == UIState.INSPECTING:
		show_panels([interactMenu])
	if ui_state == UIState.PAUSED:
		show_panels([pauseMenu])
	if ui_state == UIState.DEAD:
		show_panels([restartMenu])
		
func toggle_pause():
	if Engine.time_scale == 1.0:
		Engine.time_scale = 0.0
		change_state(UIState.PAUSED)
		player.change_state(player.PlayerState.PAUSED)
	else:
		Engine.time_scale = 1.0
		if player.player_state == player.PlayerState.DEAD:
			change_state(UIState.DEAD)
			player.change_state(player.PlayerState.DEAD)
		else:
			if gameManager.room_type == gameManager.RoomType.DUNGEON:
				change_state(UIState.KILLING)
				player.change_state(player.PlayerState.KILLING_MODE)
			elif gameManager.room_type == gameManager.RoomType.MIND:
				if player.is_inspecting:
					change_state(UIState.INSPECTING)
					player.change_state(player.PlayerState.INSPECTING)
				else:
					change_state(UIState.IDLE)
					player.change_state(player.PlayerState.IDLE)

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
