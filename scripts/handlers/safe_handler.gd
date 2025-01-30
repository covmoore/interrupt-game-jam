extends Inspectable

var isLocked = true
@export var backPanel: MeshInstance3D = null
@export var collision: CollisionShape3D = null
@export var padlock: StaticBody3D = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unlock_door():
	isLocked = false
	backPanel.free()
	collision.free()
	padlock.queue_free()
