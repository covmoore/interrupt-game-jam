extends Node3D
class_name AudioManager

@onready var dungeon_song = $dungeon_song
@onready var wind_sound = $wind

@export var camera_pivot: Node3D = null

func _ready() -> void:
	dungeon_song.stream = preload("res://sounds/songs/enter_the_dungeon.wav")
	wind_sound.stream = preload("res://sounds/wind.mp3")
	dungeon_song.connect("finished", _on_dungeon_song_finished)
	wind_sound.connect("finished", _on_wind_sound_finished)

func play_dungeon_soundtrack():
	#check if song is already playing and only play if not playing
	if not dungeon_song.is_playing():
		dungeon_song.play()

func _on_dungeon_song_finished():
	# Play the wind sound and set it to loop
	wind_sound.play()
	
func _on_wind_sound_finished():
	#repeat the wind sound
	wind_sound.play()
	
func follow_camera():
	self.global_position = camera_pivot.global_position
