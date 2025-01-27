extends Gun

@onready var ray_cast = $RayCast3D
@onready var laser_mesh: MeshInstance3D = %MeshInstance3D
@export var rail_gun_shoot: AudioStream = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_mesh = laser_mesh.mesh.duplicate()
	new_mesh.resource_local_to_scene = true
	laser_mesh.mesh = new_mesh


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot(pos = null):
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://sounds/rail_gun_fire.wav")
	add_child(audio_player)
	audio_player.play()
	var cast_point = to_local(ray_cast.get_collision_point())
	var object_hit = ray_cast.get_collider()
	if object_hit is Player:
		object_hit.take_damage(5)
	laser_mesh.mesh.height = cast_point.z
	laser_mesh.position.y = cast_point.z/2
	await pause(0.2)
	laser_mesh.mesh.height = 0
	laser_mesh.position.y = 0
	await pause(fire_rate - 0.2)
	
