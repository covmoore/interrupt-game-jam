extends Node3D
class_name MindAudioManager

@onready var mind_song = $mind_song
@onready var wind_sound = $wind

@export var camera: Node3D = null

func _ready() -> void:
	mind_song.stream = preload("res://sounds/songs/ascension_into_madness.wav")
	wind_sound.stream = preload("res://sounds/wind.mp3")
	mind_song.connect("finished", _on_mind_song_finished)
	wind_sound.connect("finished", _on_wind_sound_finished)
	play_mind_soundtrack()

func play_mind_soundtrack():
	#check if song is already playing and only play if not playing
	if not mind_song.is_playing():
		mind_song.play()

func _on_mind_song_finished():
	# Play the wind sound and set it to loop
	wind_sound.play()
	
func _on_wind_sound_finished():
	#repeat the wind sound
	wind_sound.play()
	
func follow_camera():
	self.global_position = camera.global_position
	camera.add_child(self)
