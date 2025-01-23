extends Node3D 
class_name GameManager

enum RoomType {
	DUNGEON = 0,
	MIND    = 1,
}
enum GameState {
	NORMAL = 0,
	INSPECTING
}
@export var room_type: RoomType = RoomType.DUNGEON
var gameState = GameState.NORMAL
@export var camera_path: NodePath
@export var main_room: Node3D = null
@export var rooms: Array[Node3D] = []
@export var pivot_anchors: Array[Node3D] = []

@onready var player = $Player
@onready var camera = $CameraPivot/Camera3D
@onready var camera_pivot = $CameraPivot
@onready var uiManager: UIManager = $PlayerUI

var current_room = ""
var current_inspected: Inspectable = null

signal on_cancel_interaction
signal on_back_interaction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_room(main_room.name)
	set_room_context()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_camera():
	return camera_path

func change_room_type(room: RoomType):
	room_type = room
	
func set_room_context():
	if room_type == RoomType.DUNGEON:
		player.change_state(Player.PlayerState.KILLING_MODE)
		change_state(GameState.NORMAL)
	elif room_type == RoomType.MIND:
		player.change_state(Player.PlayerState.IDLE)
		change_state(GameState.NORMAL)
	else:
		pass

func change_state(state: GameState):
	gameState = state
	if state == GameState.NORMAL:
		camera.change_state(Camera.CameraState.GLOBAL)
		player.change_state(Player.PlayerState.IDLE)
		uiManager.change_state(UIManager.UIState.IDLE)
	elif state == GameState.INSPECTING:
		camera.change_state(Camera.CameraState.FOCUSED)
		player.change_state(Player.PlayerState.INSPECTING)
		uiManager.change_state(UIManager.UIState.INSPECTING)
	else:
		pass

func set_current_inspected(item: Inspectable):
	current_inspected = item

func get_current_inspected() -> Inspectable:
	return current_inspected

func set_room(curRoom: String):
	for room in rooms:
		if room.name == curRoom:
			room.visible = true
		else:
			room.visible = false
	for anchor in pivot_anchors:
		if anchor.room == curRoom:
			camera_pivot.global_transform = anchor.global_transform
	current_room = curRoom

func get_current_room():
	return current_room

func cancel_interaction():
	set_current_inspected(null)
	change_state(GameState.NORMAL)
	emit_signal("on_cancel_interaction")

func back_interaction():
	if current_inspected.isSubInteractable:
		#print(current_inspected.parent)
		set_current_inspected(current_inspected.parent)
		change_state(GameState.INSPECTING)
		camera.select_interactable(current_inspected)
		emit_signal("on_back_interaction")
	else:
		set_current_inspected(null)
		change_state(GameState.NORMAL)
		emit_signal("on_cancel_interaction")
