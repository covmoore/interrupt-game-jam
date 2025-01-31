extends Node3D
class_name MindAudioManager

@onready var mind_song_p1 = $mindSongP1
@onready var mind_song_p2 = $mindSongP2
@onready var wind_sound = $wind

@export var camera: Node3D = null

func _ready() -> void:
	mind_song_p1.stream = preload("res://sounds/songs/ascension_into_madness_pt1.mp3")
	mind_song_p2.stream = preload("res://sounds/songs/ascension_into_madness_pt2.mp3")
	wind_sound.stream = preload("res://sounds/wind.mp3")
	mind_song_p1.connect("finished", _on_mind_song_p1_finished)
	mind_song_p2.connect("finished", _on_mind_song_p2_finished)
	wind_sound.connect("finished", _on_wind_sound_finished)
	play_mind_soundtrack()

func play_mind_soundtrack():
	#check if song is already playing and only play if not playing
	if not mind_song_p1.is_playing():
		mind_song_p1.play()

func _on_mind_song_p1_finished():
	# Play the wind sound and set it to loop
	mind_song_p2.play()

func _on_mind_song_p2_finished():
	# Play the wind sound and set it to loop
	wind_sound.play()
	
func _on_wind_sound_finished():
	#repeat the wind sound
	wind_sound.play()
	
func follow_camera():
	self.global_position = camera.global_position
	camera.add_child(self)
