extends Node3D 
class_name GameManager

enum RoomType {
	DUNGEON = 0,
	MIND    = 1,
}
@export var room_type: RoomType = RoomType.DUNGEON
@export var camera_path: NodePath

@onready var player = $Player
@onready var camera = $CameraPivot/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player:
		player.set_player_combat_mode(room_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_camera():
	return camera_path
