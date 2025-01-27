class_name Boss extends Enemy

@export var gun: Node3D = null  
@export var burst_num: int = 0
@export var burst_rate: float = 0.4
@onready var mind_trigger: Area3D = $MindTrigger

func _ready() -> void:
	mind_trigger.visible = false
	super._ready()

func attack_player(pos = null):
	if can_shoot:
		gun.shoot_burst(burst_num, burst_rate)

func take_damage(shot_by: CharacterBody3D, dmg: float):
	health -= dmg
	var mat = $Body.get_surface_override_material(0) as StandardMaterial3D
	if mat == null:
		print("Cringe... ~o~ the enemy's surface override material is null")
	else:
		var second_mat = mat.next_pass
		if second_mat == null:
			print("Cringe... ~o~ you forgot to add a next pass material to the original surface material override")
		else:
			$Body.set_surface_override_material(0, second_mat)
			await get_tree().create_timer(0.1).timeout
			$Body.set_surface_override_material(0, mat)
	if health <= 0:
		shot_by.killed_enemy(self)
		can_shoot = false
		can_move = false
		open_mind()

func open_mind():
	mind_trigger.visible = true
