class_name EnemySpawner extends Marker3D

@export var initial_delay = 0.0
@export var rounds: Array[DungeonWave]
@onready var spawn_zones
var enemy_count = 0

func _ready():
	for round in rounds:
		enemy_count += round.enemies.size()

func start(round_num: int):
	for round in rounds:
		if round.wave_number == round_num:
			spawn_enemies(round.enemies, round.spawn_rate)

func spawn_enemies(enemies: Array[PackedScene], spawn_rate: float):
	await try_await(initial_delay)
	for enemy in enemies:
		var new_enemy = enemy.instantiate()
		new_enemy.global_transform = global_transform
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_enemy)
		new_enemy.spawn()
		await try_await(spawn_rate)

func get_total_enemies():
	return enemy_count

func get_enemies_in_wave(wave_number: int):
	var res = 0
	for round in rounds:
		if round.wave_number == wave_number:
			res = round.enemies.size()
	return res

func try_await(pause_time: float):
	await get_tree().create_timer(pause_time).timeout
