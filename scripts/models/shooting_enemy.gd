class_name ShootingEnemy extends Enemy

@export var gun: Node3D = null  
@export var burst_num: int = 0
@export var burst_rate: float = 0.4

func attack_player(pos = null):
	if can_shoot:
		gun.shoot_burst(burst_num, burst_rate)
