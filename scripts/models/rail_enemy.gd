class_name RailEnemy extends Enemy

@export var gun: Node3D = null

func _physics_process(_delta):
	if can_rotate:
		gun.look_at(player.global_transform.origin, Vector3.UP)
		super._physics_process(_delta)

func attack_player(pos = null):
	if can_shoot:
		can_shoot = false
		await charge()
		await gun.shoot()
		can_shoot = true
		can_rotate = true

func charge():
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = preload("res://sounds/rail_gun_charge_up.wav")
	add_child(audio_player)
	audio_player.play()
	await pause(1)
	can_rotate = false
	await pause(0.5)
