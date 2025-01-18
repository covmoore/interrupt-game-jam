extends Node

var PlayerScence = preload("res://prefabs/player.tscn")
var player_instance = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_instance = PlayerScence.instantiate()
	add_child(player_instance)
	player_instance.position = Vector3(0,0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
