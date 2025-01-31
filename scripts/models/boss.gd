class_name Boss extends Enemy

@export var gun: BossGun = null
@export var burst_num: int = 0
@export var burst_rate: float = 0.4
@onready var mind_trigger: MindTrigger = $MindTrigger
@onready var root_node
@onready var player_ui_node

func _ready() -> void:
	mind_trigger.visible = false
	root_node = get_tree().current_scene
	player_ui_node = root_node.get_node("PlayerUI")
	super._ready()

func attack_player(pos = null):
	if can_shoot:
		gun.attack(burst_num, burst_rate, player)

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
		can_rotate = false
		open_mind()

func open_mind():
	mind_trigger.visible = true
	mind_trigger.make_hackable()
	player_ui_node.change_state(player_ui_node.UIState.BOSS_DEFEATED)
