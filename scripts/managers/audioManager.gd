extends Node3D
class_name AudioManager

@onready var dungeon_song = $dungeon_song
@export var camera_pivot: Node3D = null

func play_dungeon_soundtrack():
	#check if song is already playing and only play if not playing
	if not dungeon_song.is_playing():
		dungeon_song.play()
	
func follow_camera():
	self.global_position = camera_pivot.global_position

func _ready() -> void:
	dungeon_song.stream = preload("res://sounds/songs/enter_the_dungeon.wav")
