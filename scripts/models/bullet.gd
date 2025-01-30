class_name Bullet extends Node3D

@export var lifespan: float = 2.0
@export var speed: float = 70.0
var shot_by: CharacterBody3D = null
@export var damage: float = 1.0

func _ready():
	self.connect("body_entered", _on_body_entered)
	await(get_tree().create_timer(lifespan)).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)

func _on_body_entered(body: Node3D) -> void:
	var name_shot_by = ""
	if shot_by != null:
		name_shot_by = shot_by.name
	if(body.is_in_group("enemies") and name_shot_by == "Player"):
		body.take_damage(shot_by, damage)
	elif(body.name == "Player" and name_shot_by != "Player"):
		body.take_damage(damage)
	queue_free()
