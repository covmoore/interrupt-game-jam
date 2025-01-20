extends Node3D

@export var lifespan: float = 2.0
@export var speed: float = 70.0

func _ready():
	await(get_tree().create_timer(lifespan)).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * speed * delta)


func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("enemies")):
		body.queue_free()
