extends Node

@onready var player = $"../Player"
@onready var camera = $"../CameraPivot"
@onready var current_room = "Room0"

var room_positions = {
	"Room0" : -12,
	"Room1" : 12
}

func _process(delta: float) -> void:
	pass
