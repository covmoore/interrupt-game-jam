extends Node3D

@export var laser_sounds: Array[AudioStream] = []
@export var time_to_airstrike: float = 2.5
@export var airstrike_laser_time: float = 3
#@onready var ray_cast: RayCast3D = $RayCast3D
@onready var laser_mesh: MeshInstance3D = $Area3D2/MeshInstance3D
var audio_player: AudioStreamPlayer = null
var isLasering = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser_mesh.visible = false
	audio_player = AudioStreamPlayer.new()
	var rand = RandomNumberGenerator.new().randi_range(0, laser_sounds.size()-1)
	audio_player.stream = laser_sounds[rand]
	var new_mesh = laser_mesh.mesh.duplicate()
	new_mesh.resource_local_to_scene = true
	laser_mesh.mesh = new_mesh
	add_child(audio_player)
	
	await pause(time_to_airstrike)
	audio_player.play()
	laser_mesh.visible = true
	isLasering = true
	await pause(airstrike_laser_time)
	isLasering = false
	queue_free()

func pause(time: float):
	await get_tree().create_timer(time).timeout


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if isLasering and body is Player:
		body.take_damage(5)
