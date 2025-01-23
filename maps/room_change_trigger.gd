extends Area3D

@export var room = ""
var room_discovered = false
@onready var collider: CollisionShape3D = $CollisionShape3D
@onready var gameManager: GameManager = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	var cur_room = gameManager.get_current_room()
	if cur_room != room and body.name == "Player":
		gameManager.set_room(room)
