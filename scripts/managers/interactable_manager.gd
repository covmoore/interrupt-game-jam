extends Node3D

var interactables: Array[Interactable] = []
@export var gameManager: GameManager = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("interactable")
	for node in nodes:
		if node is Interactable:
			node.connect_button(gameManager)
			interactables.append(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
