extends Enemy

@export var explosion_radius: float = 3
@export var time_to_explode: float = 1
@export var damage: float = 1
@export var mesh: MeshInstance3D = null
@export var overlay: Material = null
@export var explosion_sound: AudioStream = null
@export var explosion_fx: CPUParticles3D = null
var blink_rate = 0.2

func attack_player(pos = null):
	if player != null and can_shoot:
		can_move = false
		can_shoot = false
		await explosion_timer()
		await explode(player)

func explosion_timer():
	mesh_blink()
	await pause(time_to_explode)

func explode(player: Player):
	explosion_fx.reparent(self.get_parent())
	explosion_fx.emitting = true
	audio_player.stream = explosion_sound
	add_child(audio_player)
	audio_player.play()
	var distance_to_player = global_position.distance_to(player.global_transform.origin)
	if distance_to_player <= explosion_radius:
		player.take_damage(damage)
	player.killed_enemy(self)
	visible = false
	await pause(1.5)
	queue_free()

func mesh_blink():
	var original_overlay = mesh.material_overlay
	var blink = false
	while(true):
		if blink:
			mesh.material_overlay = original_overlay
			blink = false
		else:
			mesh.material_overlay = overlay
			blink = true
		await pause(blink_rate)
