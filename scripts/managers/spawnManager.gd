extends Node

@export var enemy_scene:PackedScene
@export var spawn_rate = 1

@onready var spawn_zones

var can_spawn = true
var rng = RandomNumberGenerator.new()
var enemy_count = 0

func _ready():
	spawn_zones = $".".get_children()
	await(get_tree().create_timer(spawn_rate)).timeout
	
func _process(delta: float):
	if can_spawn:
		can_spawn = false
		var rand_spawn_value = rng.randi_range(0, len(spawn_zones)-1)
		var rand_spawn = spawn_zones[rand_spawn_value]
		var new_enemy = enemy_scene.instantiate()
		new_enemy.name = "Enemy" + str(enemy_count)
		new_enemy.global_transform = rand_spawn.global_transform
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_enemy)
		await get_tree().create_timer(spawn_rate).timeout
		can_spawn = true
