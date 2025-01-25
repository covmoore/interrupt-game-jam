class_name RoomManager extends Node3D

var current_wave = 0
@export var player: CharacterBody3D
@export var number_of_waves = 0
@export var doors: Array[Node3D] = []
@export var enemySpawners: Array[Node3D] = []
var room_cleared = false
var total_enemies = 0
var total_wave_enemies = 0
var total_wave_killed = 0
var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemySpawners.size() > 0:
		for spawner in enemySpawners:
			total_enemies += spawner.get_total_enemies()
	if player != null:
		player.connect("on_enemy_killed", _on_enemy_killed)

func start_room():
	active = true
	start_next_wave()

func start_next_wave():
	total_wave_enemies = 0
	current_wave += 1
	if enemySpawners.size() > 0:
		for spawner in enemySpawners:
			if spawner is EnemySpawner:
				total_wave_enemies += spawner.get_enemies_in_wave(current_wave)
				spawner.start(current_wave)
	if current_wave > number_of_waves:
		on_room_cleared()

func on_room_cleared():
	print("Room Cleared: %s" % self.name)
	if not room_cleared:
		room_cleared = true
		open_doors()

func open_doors():
	if doors.size() > 0:
		for door in doors:
			door.free()

func _on_enemy_killed():
	if active:
		total_wave_killed += 1
		if total_wave_killed >= total_wave_enemies:
			total_wave_killed = 0
			start_next_wave()
