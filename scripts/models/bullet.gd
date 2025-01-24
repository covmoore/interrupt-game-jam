class_name Bullet extends Node3D

@export var lifespan: float = 2.0
@export var speed: float = 70.0
var shot_by: CharacterBody3D = null
var damage: float = 0.0

func _ready():
	self.connect("body_entered", _on_body_entered)
	await(get_tree().create_timer(lifespan)).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("enemies") and shot_by.name == "Player"):
		body.take_damage(shot_by, damage)
	elif(body.name == "Player" and shot_by != null):
		body.take_damage(damage)
	queue_free()
