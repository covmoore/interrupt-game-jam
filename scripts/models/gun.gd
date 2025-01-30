class_name Gun extends Node3D

@export var bullet_scene: PackedScene
@export var muzzle_speed: float = 50.0
@export var fire_rate:float = 0.2
@export var user: CharacterBody3D = null
var can_shoot = true

@onready var audio_player

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://sounds/laser.wav")
	add_child(audio_player)
	

func shoot(pos = null):
	if can_shoot:
		can_shoot = false
		await fire(fire_rate, pos)
		can_shoot = true

func shoot_burst(burst_num: int, burst_rate: float, enemy: Enemy = null):
	if can_shoot:
		can_shoot = false
		for i in range(0,burst_num):
			can_shoot = false
			await fire(burst_rate)
		await pause(fire_rate)
		can_shoot = true

func fire(time: float, pos = null):
	var new_bullet = bullet_scene.instantiate()
	if audio_player != null:
		audio_player.play()
	new_bullet.shot_by = user
	new_bullet.damage = 1
	new_bullet.global_transform = $Muzzle.global_transform
	if pos != null:
		new_bullet.look_at_from_position(global_position, pos, Vector3(0,1,0), true)
	var scene_root = get_tree().get_root().get_children()[0]
	scene_root.add_child(new_bullet)
	await pause(time)
	

func pause(time: float):
	await get_tree().create_timer(time).timeout
