extends Control
class_name UIPanel

@export var hidesUI = true
@export var pausesGame = false
@onready var timer = $Timer
@onready var uiManager: UIManager = $"../../.."
var gameManager:GameManager = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameManager = uiManager.gameManager

func _process(delta: float) -> void:
	if uiManager.ui_state == uiManager.UIState.IDLE and gameManager != null:
		var time_elapsed: float = gameManager.timer.time_left
		var minutes: int = time_elapsed / 60
		var seconds: int = fmod(time_elapsed, 60)
		timer.text = "%02d:%02d" % [minutes,seconds]

func show():
	super()
	if uiManager.ui_state == uiManager.UIState.IDLE:
		timer.show()
	else:
		timer.hide()

func hide():
	super()
