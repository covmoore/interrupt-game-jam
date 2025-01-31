extends Area3D

@export var room = ""
var room_discovered = false
@export var audioManager: AudioManager = null
@export var collider: CollisionShape3D = null
@export var gameManager: GameManager = null
@export var playerUI:UIManager = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	

func _on_body_entered(body: Node3D) -> void:
	var cur_room = gameManager.get_current_room()
	if cur_room != room and body.name == "Player":
		gameManager.set_room(room)
		if audioManager != null:
			audioManager.follow_camera() 
		if gameManager.get_current_room() == "room1":
			audioManager.play_dungeon_soundtrack()
		if gameManager.get_current_room() == "control_room":
			playerUI.change_state(playerUI.UIState.WON)
