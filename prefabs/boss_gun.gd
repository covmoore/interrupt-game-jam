class_name BossGun extends Gun

enum AttackType {
	AIR_STRIKE = 0,
	LASER_BEAM = 1,
	MACHINE_GUN = 2,
}
var current_attack: AttackType = AttackType.MACHINE_GUN

var is_attacking = false

@onready var ray_cast = $RayCast3D
@onready var laser_mesh: MeshInstance3D = $RayCast3D/MeshInstance3D
@onready var boss: Boss = $"../.."
@export var rail_gun_shoot: AudioStream = null
@export var number_of_airstrikes: int = 4
@export var airstrike: PackedScene = null
var player: Player = null

func _ready() -> void:
	var new_mesh = laser_mesh.mesh.duplicate()
	new_mesh.resource_local_to_scene = true
	laser_mesh.mesh = new_mesh
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)

func attack(burst_num: int, burst_rate: float, player: Player):
	if !is_attacking:
		is_attacking = true
		if current_attack == AttackType.AIR_STRIKE:
			await air_strike(player)
		elif current_attack == AttackType.LASER_BEAM:
			await laser_beam()
		elif current_attack == AttackType.MACHINE_GUN:
			await machine_gun(burst_num, burst_rate)
		else:
			print("cringggeeee dude this is an error")
		next_attack()
		is_attacking = false

func next_attack():
	if current_attack >= AttackType.size()-1:
		current_attack = AttackType.AIR_STRIKE
	else:
		current_attack += 1

func air_strike(player: Player):
	await fire_air_strike(player)
	await pause(3)

func laser_beam():
	await charge_beam()
	await fire_laser_beam()
	await charge_beam()
	await fire_laser_beam()
	await charge_beam()
	await fire_laser_beam()
	await pause(2)

func machine_gun(burst_num: int, burst_rate: float):
	await fire_machine_gun(burst_num, burst_rate)

func fire_air_strike(player: Player):
	for strike in range(0, number_of_airstrikes):
		var player_pos = player.global_position
		var rand_x = RandomNumberGenerator.new().randf_range(-2,2)
		var rand_z = RandomNumberGenerator.new().randf_range(-2,2)
		var strike_instance = airstrike.instantiate()
		var scene_root = get_tree().get_root().get_children()[0]
		strike_instance.global_position = Vector3(player_pos.x + rand_x, 0, player_pos.z)
		scene_root.add_child(strike_instance)
		await pause(0.4)

func charge_beam():
	audio_player.stream = preload("res://sounds/rail_gun_charge_up.wav")
	audio_player.pitch_scale = 2
	audio_player.play()
	await pause(0.5)
	audio_player.pitch_scale = 1
	boss.can_rotate = false
	await pause(0.4)


func fire_laser_beam():
	audio_player.stream = preload("res://sounds/rail_gun_fire.wav")
	audio_player.play()
	var cast_point = to_local(ray_cast.get_collision_point())
	var object_hit = ray_cast.get_collider()
	if object_hit is Player:
		object_hit.take_damage(5)
	laser_mesh.mesh.height = cast_point.z
	laser_mesh.position.y = cast_point.z/2
	await pause(0.2)
	boss.can_rotate = true
	laser_mesh.mesh.height = 0
	laser_mesh.position.y = 0
	await pause(fire_rate - 0.2)

func fire_machine_gun(burst_num: int, burst_rate: float):
	audio_player.stream = preload("res://sounds/laser.wav")
	await super.shoot_burst(burst_num, burst_rate)
